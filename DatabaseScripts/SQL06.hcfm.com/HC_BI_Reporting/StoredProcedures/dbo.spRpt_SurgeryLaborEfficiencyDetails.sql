/* CreateDate: 07/14/2011 08:25:49.997 , ModifyDate: 11/09/2012 10:11:22.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spRpt_SurgeryLaborEfficiencyDetails
-- Procedure Description:
--
-- Created By:				Alex Pasieka
-- Implemented By:			Alex Pasieka
-- Last Modified By:		Kevin Murdoch
--
-- Date Created:			6/29/2009
-- Date Implemented:
-- Date Last Modified:		7/14/2011
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:		Surgery Labor Efficiency Report

================================================================================================
**NOTES**
	8/4/2009 -- AP -- Change division calculations to use the dbo.DivideDecimal function, in order to
		eliminate the possibility of a "divide by zero" error in the report.
	8/20/2009  -- AP -- Changed to accept a date range passed in.
	9/14/2009  -- AP -- Changed the sort order for the output.
	9/14/2009  -- AP -- Set the SpeedDivisor and the PayrollDivisor to fixed values of 80 and 5.
	10/26/2009 -- AP -- Do not include employees with "Salary Hours"
	7/14/2011  -- KM -- Migrate report to SQL06
	11/09/2012 -- MB -- Changed query so that if a surgery center is chosen, the center number is
						represented properly (WO# 80984)
================================================================================================

Sample Execution:

EXEC spRpt_SurgeryLaborEfficiencyDetails '9/1/2012', '9/28/2012', 2, '301'
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_SurgeryLaborEfficiencyDetails] (
	@PeriodBeginDate DATETIME
,	@PeriodEndDate	DATETIME
,	@ReportType TINYINT
,	@RecordID VARCHAR(30)	)

/***** Report Types **************
****** 1 - Doctor Region	******
****** 2 - Center			******
****** 3 - Employee 		******
*********************************/
AS
BEGIN

	--SET FMTONLY OFF
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

	SET @StartDate = @PeriodBeginDate
	SET @EndDate = DATEADD(mi, -1, DATEADD(dd, 1, @PeriodEndDate))
	SET @EndCheckDate = DATEADD(dd, 7, @PeriodEndDate)
	SET @EndCheckDate = DATEADD(mi, -1, DATEADD(dd, 1, @EndCheckDate))
	SET @BeginCheckDate = DATEADD(dd, 20, @StartDate)
	SET @CheckDate = DATEADD(dd, 7, @PeriodEndDate)
	SET @NumPayPeriods = (DATEDIFF(d, @StartDate, @EndDate) + 1) / 14
	SET @PayrollDivisor = 5
	SET @SpeedDivisor = 80

	-- Get Employee info and Cut & Place counts, put into temp table
	SELECT
		[EmployeeFullName],
		[Region].[RegionDescription],
		[DoctorRegion].[DoctorRegionDescription],
		[DoctorRegion].DoctorRegionSSID,
		[Employee].[CenterSSID],
		[Employee].[EmployeeLastName],
		[Employee].[EmployeeFirstName],
		[Client].ClientFirstName AS 'ClientFirstName',
		[Client].ClientLastName AS 'ClientLastName',
		dbo.DateOnly([Appointment].AppointmentDate) 'AppointmentDate',
		SUM(ISNULL([CutCount], 0)) AS 'CutCount',
		SUM(ISNULL([PlaceCount], 0))AS 'PlaceCount',
		SUM(ISNULL([CutCount], 0)) + SUM(ISNULL([PlaceCount], 0)) AS 'CutAndPlaceTotal'
	INTO #Employees
	FROM    dbo.synHC_CMS_DDS_vwFactSurgeryCloseOutEmployee SurgeryCloseoutEmployee
		LEFT OUTER JOIN dbo.synHC_CMS_DDS_vwDimAppointment Appointment
			ON [SurgeryCloseoutEmployee].[AppointmentKey] = [Appointment].[AppointmentKey]
		INNER JOIN dbo.synHC_CMS_DDS_vwDimClient Client
			ON [Appointment].[ClientKey] = [Client].[ClientKey]
		INNER JOIN dbo.synHC_CMS_DDS_vwDimEmployee Employee
			ON [SurgeryCloseoutEmployee].[EmployeeKey] = [Employee].[EmployeeKey]
		INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter Center
			ON [Employee].[CenterSSID] = [Center].[CenterSSID]
		INNER JOIN dbo.synHC_ENT_DDS_vwDimRegion Region
			ON Center.[RegionKey] = [Region].[RegionKey]
		INNER JOIN dbo.synHC_ENT_DDS_vwDimDoctorRegion DoctorRegion
			ON [Center].[DoctorRegionKey] = [DoctorRegion].[DoctorRegionKey]
		WHERE   [Appointment].[AppointmentDate] BETWEEN @StartDate AND @EndDate
	GROUP BY
		[EmployeeFullName],
		[Region].[RegionDescription],
		[DoctorRegion].[DoctorRegionDescription],
		[DoctorRegion].DoctorRegionSSID,
		[Employee].[CenterSSID],
		[Employee].[EmployeeLastName],
		[Employee].[EmployeeFirstName],
		[Client].ClientFirstName,
		[Client].ClientLastName,
		[Appointment].AppointmentDate
	ORDER BY Employee.CenterSSID, [EmployeeFullName]


	-- Get Employee Payroll hours, put into temp table
	SELECT
		C.ReportingCenterSSID AS 'PerformerHomeCenter'
	,	h.[LastName]
	,	h.[FirstName]
	,	h.[HomeDepartment]
	,	h.[EmployeeNumber]
	,	h.[EmployeeID]
	,	dbo.DateOnly(e.[HireDate]) 'HireDate'
	,	dbo.DateOnly([PeriodBegin]) 'PeriodBegin'
	,	dbo.DateOnly([PeriodEnd]) 'PeriodEnd'
	,	dbo.DateOnly([CheckDate]) 'CheckDate'
	,	DATEDIFF(month, dbo.DateOnly(e.[HireDate]), GETDATE()) 'MonthsEmployeed'
	,	SUM((ISNULL([SalaryHours], 0) + ISNULL([RegularHours], 0) + ISNULL([OverTimeHours], 0) + ISNULL([PTHours], 0)
			+ ISNULL([PTO_Hours], 0) + ISNULL([FuneralHours], 0) + ISNULL([JuryHours], 0)) / 1000) AS 'PayrollHours'
	,	SUM(CAST((ISNULL(SalaryEarnings, 0) + ISNULL(RegularEarnings, 0) + ISNULL(OTEarnings, 0) + ISNULL(PTEarnings, 0)
			+ ISNULL(PTOEarnings, 0) + ISNULL(FuneralEarnings, 0) + ISNULL(JuryEarnings, 0)) AS DECIMAL(10, 2)) / 1000.00) AS 'Earnings'
	INTO #Hours
	FROM HC_BI_Reporting.dbo.[vwEmployeeHoursCertipaySurgery] h
		INNER JOIN HC_BI_Reporting.dbo.[vwEmployeeCertipaySurgery] e
			ON h.[EmployeeID] = e.[EmployeeID]
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON h.PerformerHomeCenter = C.CenterSSID
	WHERE
		(h.[PerformerHomeCenter] LIKE '3%' OR h.[PerformerHomeCenter] LIKE '5%') AND
		[CheckDate] BETWEEN @BeginCheckDate AND @EndCheckDate
		AND ISNULL([SalaryHours], 0) = 0
	GROUP BY
		C.ReportingCenterSSID
	,	h.[LastName]
	,	h.[FirstName]
	,	h.[HomeDepartment]
	,	h.[EmployeeNumber]
	,	h.[EmployeeID]
	,	dbo.DateOnly(e.[HireDate])
	,	dbo.DateOnly([PeriodBegin])
	,	dbo.DateOnly([PeriodEnd])
	,	dbo.DateOnly([CheckDate])
	ORDER BY C.ReportingCenterSSID, [LastName], [FirstName]


	-- Join the 2 temp tables
	-- By Doctor/Region
	IF (@ReportType IN (1))
	BEGIN
		SELECT
			c.[Centerssid] AS 'CenterID'
		,	c.CenterDescription AS 'Center'
		,	e.*
		,	h.*
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) AS 'CutAndPlacedPerHourWorked'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) AS 'PerDollarEarned'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) / @PayrollDivisor AS 'PayrollEfficiency'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) / @SpeedDivisor AS 'SpeedEfficiency'

		FROM [#Employees] e
			LEFT OUTER JOIN [#Hours] h
				ON e.CenterSSID = h.PerformerHomeCenter
				AND e.EmployeeLastName = h.LastName
				AND e.EmployeeFirstName = h.FirstName
			INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter c
				ON h.[PerformerHomeCenter] = c.[CenterSSID]
		WHERE h.[PerformerHomeCenter] IS NOT NULL
			AND e.[DoctorRegionSSID] = @RecordID
		ORDER BY e.[CenterSSID], e.[AppointmentDate]
	END

	-- By Center
	IF (@ReportType IN (2))
	BEGIN
		SELECT
			c.[Centerssid] AS 'CenterID'
		,	c.CenterDescription AS 'Center'
		,	e.*
		,	h.*
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) AS 'CutAndPlacedPerHourWorked'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) AS 'PerDollarEarned'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) / @PayrollDivisor AS 'PayrollEfficiency'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) / @SpeedDivisor AS 'SpeedEfficiency'

		FROM [#Employees] e
			LEFT OUTER JOIN [#Hours] h
				ON e.CenterSSID = h.PerformerHomeCenter
				AND e.EmployeeLastName = h.LastName
				AND e.EmployeeFirstName = h.FirstName
			INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter c
				ON h.[PerformerHomeCenter] = c.[CenterSSID]
		WHERE h.[PerformerHomeCenter] IS NOT NULL
			AND e.[CenterSSID] = @RecordID
		ORDER BY e.[CenterSSID], e.[AppointmentDate]
	END

	-- By Employee
	IF (@ReportType IN (3))
	BEGIN
		SELECT
			c.[CenterSSID] AS 'CenterID'
		,	c.CenterDescription AS 'Center'
		,	e.*
		,	h.*
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) AS 'CutAndPlacedPerHourWorked'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) AS 'PerDollarEarned'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.Earnings) AS DECIMAL(6, 1)) / @PayrollDivisor AS 'PayrollEfficiency'
	,	CAST(dbo.Divide_Decimal(e.CutAndPlaceTotal, h.PayrollHours) AS DECIMAL(8, 2)) / @SpeedDivisor AS 'SpeedEfficiency'

		FROM [#Employees] e
			LEFT OUTER JOIN [#Hours] h
				ON e.CenterSSID = h.PerformerHomeCenter
				AND e.EmployeeLastName = h.LastName
				AND e.EmployeeFirstName = h.FirstName
			INNER JOIN dbo.synHC_ENT_DDS_vwDimCenter c
				ON h.[PerformerHomeCenter] = c.[CenterSSID]
		WHERE h.[PerformerHomeCenter] IS NOT NULL
			AND h.[EmployeeID] = @RecordID
	ORDER BY e.[CenterSSID], e.[AppointmentDate]
	END

END
GO
