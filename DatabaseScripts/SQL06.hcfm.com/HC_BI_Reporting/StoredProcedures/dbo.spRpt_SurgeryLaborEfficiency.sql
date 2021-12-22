/*===============================================================================================
-- Procedure Name:			spRpt_SurgeryLaborEfficiency
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		Kevin Murdoch
--
-- Date Created:			6/25/2009
-- Date Implemented:
-- Date Last Modified:		7/13/2011
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:		Surgery Labor Efficiency Report

================================================================================================
**NOTES**
08/04/2009 - AP - Change division calculations to use the dbo.DivideDecimal function, in order to eliminate the possibility of a "divide by zero" error in the report.
08/20/2009 - AP - Changed to accept a date range passed in.
09/14/2009 - AP - Changed the sort order for the output.
09/14/2009 - AP - Set the SpeedDivisor and the PayrollDivisor to fixed values of 80 and 5.
12/01/2009 - AP - Display HireDate and MonthsEmployeed
03/02/2010 - AP - When setting the checkdate date range, go one additional day forward and one back, to account for holidays.
03/02/2010 - AP - Do not include managers.
07/13/2011 - KM - Migrate to SQL06 BI environment
08/09/2012 - KM - Added in ISNULL fix because records were missing for employees
11/08/2012 - MB - Returned non-surgery center number instead of actual surgery center number for hours the query could join back to the other data
11/18/2013 - DL - Updated procedure to reference the EmployeeHoursCertipay in HC_Accounting
================================================================================================

Sample Execution:

EXEC spRpt_SurgeryLaborEfficiency '9/1/2012', '9/28/2012'
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryLaborEfficiency] (
	@PeriodStartDate	DATETIME
,	@PeriodEndDate		DATETIME	)
AS
BEGIN

	SET FMTONLY OFF
	SET NOCOUNT OFF

	--Dispose of needed temp table objects if they already exist
	IF OBJECT_ID('tempdb..#Employees') IS NOT NULL
		DROP TABLE #Employees
	IF OBJECT_ID('tempdb..#Hours') IS NOT NULL
		DROP TABLE #Hours

	DECLARE
		@StartDate	DATETIME
	,	@EndDate	DATETIME
	,	@CheckDate	DATETIME
	,	@PayrollDivisor INT
	,	@SpeedDivisor INT
	,	@NumPayPeriods SMALLINT
	,	@BeginCheckDate	SMALLDATETIME
	,	@EndCheckDate	SMALLDATETIME


	SET @StartDate = @PeriodStartDate
	SET @EndDate = DATEADD(mi, -1, DATEADD(dd, 1, @PeriodEndDate))
	SET @EndCheckDate = DATEADD(dd, 7, @PeriodEndDate)
	SET @EndCheckDate = DATEADD(mi, -1, DATEADD(dd, 2, @EndCheckDate))
	SET @BeginCheckDate = DATEADD(dd, 19, @StartDate)
	SET @NumPayPeriods = (DATEDIFF(d, @StartDate, @EndDate) + 1) / 14
	SET @PayrollDivisor = 5
	SET @SpeedDivisor = 80
--
-- Get Employee info and Cut & Place counts, put into temp table
--
	SELECT
		[Employee].EmployeeFullName,
		[Region].[RegionDescription],
		[DoctorRegion].DoctorRegionSSID,
		[DoctorRegion].[DoctorRegionDescription],
		[Employee].[CenterSSID],
		[Employee].[EmployeeLastName] 'EmployeeLastName',
		[Employee].[EmployeeFirstName] 'EmployeeFirstName',
		SUM(ISNULL([CutCount], 0)) AS 'CutCount',
		SUM(ISNULL([PlaceCount], 0))AS 'PlaceCount',
		SUM(ISNULL([CutCount], 0)) + SUM(ISNULL([PlaceCount], 0)) AS 'CutAndPlaceTotal'
	INTO #Employees
	FROM    dbo.synHC_CMS_DDS_vwFactSurgeryCloseOutEmployee SurgeryCloseoutEmployee
		LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimAppointment Appointment
			ON [SurgeryCloseoutEmployee].AppointmentKey = [Appointment].AppointmentKey
		left outer JOIN dbo.synHC_CMS_DDS_vwDimEmployee Employee
			ON [SurgeryCloseoutEmployee].[EmployeeKey] = [Employee].[EmployeeKey]
		left outer join dbo.synHC_ENT_DDS_vwDimCenter Center
			ON [Employee].[CenterSSID] = [Center].[CenterSSID]
		INNER JOIN dbo.synHC_ENT_DDS_vwDimRegion Region
			ON Center.[RegionKey] = [Region].[RegionKey]
		INNER JOIN dbo.synHC_ENT_DDS_vwDimDoctorRegion DoctorRegion
			ON [Center].[DoctorRegionKey] = [DoctorRegion].[DoctorRegionKey]
	WHERE   [Appointment].[AppointmentDate] BETWEEN @StartDate AND @EndDate
	GROUP BY
		[Employee].EmployeeFullName,
		[Region].[RegionDescription],
		[DoctorRegion].DoctorRegionSSID,
		[DoctorRegion].[DoctorRegionDescription],
		[Employee].[CenterSSID],
		[Employee].[EmployeeLastName],
		[Employee].[EmployeeFirstName]
	ORDER BY Employee.CenterSSID, [EmployeeFullName]
--
-- Get Employee Payroll hours, put into temp table
--
	SELECT
		C.ReportingCenterSSID AS 'PerformerHomeCenter'
	,	h.[LastName]
	,	h.[FirstName]
	,	h.[HomeDepartment]
	,	h.[EmployeeNumber]
	,	h.[EmployeeID]
	,	e.[HireDate]
	,	SUM((ISNULL([SalaryHours], 0) + ISNULL([RegularHours], 0) + ISNULL([OverTimeHours], 0) + ISNULL([PTHours], 0)
			+ ISNULL([PTO_Hours], 0) + ISNULL([FuneralHours], 0) + ISNULL([JuryHours], 0)) / 1000) AS 'PayrollHours'
	,	SUM(CAST((ISNULL(SalaryEarnings, 0) + ISNULL(RegularEarnings, 0) + ISNULL(OTEarnings, 0) + ISNULL(PTEarnings, 0)
			+ ISNULL(PTOEarnings, 0) + ISNULL(FuneralEarnings, 0) + ISNULL(JuryEarnings, 0)) AS DECIMAL(10, 2)) / 1000.00) AS 'Earnings'
	INTO #Hours
	FROM [HC_Accounting].[dbo].[EmployeeHoursCertipay] h
		INNER JOIN [HC_BI_Reporting].dbo.[EmployeeCertipay] e
			ON h.[EmployeeID] = e.[EmployeeID]
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON h.PerformerHomeCenter = C.CenterSSID
	WHERE (h.[PerformerHomeCenter] LIKE '3%' OR h.[PerformerHomeCenter] LIKE '5%')
		AND [CheckDate] BETWEEN @BeginCheckDate AND @EndCheckDate
		--AND ISNULL([SalaryHours], 0) = 0
	GROUP BY
		C.ReportingCenterSSID
	,	h.[LastName]
	,	h.[FirstName]
	,	h.[HomeDepartment]
	,	h.[EmployeeNumber]
	,	h.[EmployeeID]
	,	e.[HireDate]
	ORDER BY C.ReportingCenterSSID, [LastName], [FirstName]
--
-- Join the 2 temp tables
--
	SELECT
		c.[CenterDescription]
	,	e.*
	,	h.*
	,	ISNULL(CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)), 0) AS 'CutAndPlacedPerHourWorked'
	,	ISNULL(CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)), 0) AS 'PerDollarEarned'
	,	ISNULL(CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) / @PayrollDivisor, 0) AS 'PayrollEfficiency'
	,	ISNULL(CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) / @SpeedDivisor, 0) AS 'SpeedEfficiency'
	INTO #Output
	FROM [#Employees] e
		LEFT OUTER JOIN [#Hours] h
			ON e.CenterSSID = h.PerformerHomeCenter
			AND e.EmployeeLastName = h.LastName
			AND e.EmployeeFirstName = h.FirstName

		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter c
			ON ISNULL(h.[PerformerHomeCenter],e.CenterSSID) = c.[Centerssid]
	WHERE ISNULL(h.[PerformerHomeCenter],e.CenterSSID) IS NOT NULL
--
-- Join the output table with the Doctor Region table, in order to ensure that all doctors appear
-- on the report, even if they have no surgeries for the specified date range.
--
	SELECT
		ISNULL(o.[CenterDescription], '') AS 'Center'
	,	ISNULL(o.EmployeeFullName, '') AS 'EmployeeFullNameCalc'
	,	ISNULL(o.RegionDescription, '')  AS 'RegionDescription'
	,	ISNULL(o.DoctorRegionSSID, '') AS 'DoctorRegionID'
	,	ISNULL(o.DoctorRegionDescription, '') AS 'DoctorRegionDescription'
	,	ISNULL(o.CenterSSID, '') AS 'CenterID'
	,	ISNULL(o.EmployeeLastName, '') AS 'EmployeeLastName'
	,	ISNULL(o.EmployeeFirstName, '') AS 'EmployeeFirstName'
	,	ISNULL(o.CutCount, 0) AS 'CutCount'
	,	ISNULL(o.PlaceCount, 0) AS 'PlaceCount'
	,	ISNULL(o.CutAndPlacetotal, 0) AS 'CutAndPlaceTotal'
	,	ISNULL(o.PerformerHomeCenter, '') AS 'PerformerHomeCenter'
	,	LastName
	,	FirstName
	,	HomeDepartment
	,	EmployeeNumber
	,	EmployeeID
	,	CONVERT(varchar, o.HireDate, 101) AS 'HireDate'
	,	DATEDIFF(mm, o.HireDate, @PeriodEndDate) AS 'MonthsEmployeed'
	--,	PeriodBegin
	--,	PeriodEnd
	--,	CheckDate
	,	ISNULL(PayrollHours, 0) AS 'PayrollHours'
	,	ISNULL(Earnings, 0) AS 'Earnings'
	,	ISNULL(CutAndPlacedPerHourWorked, 0) AS 'CutAndPlacedPerHourWorked'
	,	ISNULL(PerDollarEarned, 0) AS 'PerDollarEarned'
	,	ISNULL(PayrollEfficiency, 0) AS 'PayrollEfficiency'
	,	ISNULL(SpeedEfficiency, 0) AS 'SpeedEfficiency'
	,	d.DoctorRegionSSID 'Doctor_DoctorRegionID'
	,	d.DoctorRegionDescription 'Doctor_DoctorDescription'
	FROM HC_BI_ENT_DDS.bi_ent_dds.vwDimDoctorRegion d
		LEFT OUTER JOIN #Output o
			ON d.[DoctorRegionSSID] = o.DoctorRegionSSID
	WHERE d.DoctorRegionKey>0 and d.Active = 1
END
