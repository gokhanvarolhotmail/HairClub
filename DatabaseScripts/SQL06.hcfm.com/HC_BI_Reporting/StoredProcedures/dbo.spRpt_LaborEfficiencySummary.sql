/*
==============================================================================

PROCEDURE:				spRpt_LaborEfficiencySummary

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		04/16/2012

==============================================================================
DESCRIPTION:	Labor Efficiency
==============================================================================
NOTES:
2012-12-18 - HD - Updated the employee join to use the EmployeePayrollId instead of joining on Center and Initials
2013-01-22 - KM - No modifications
09/05/2012 - MB - Updated procedure so that hours for visiting stylists are listed under visiting center (#90626)
10/11/2013 - DL - Updated procedure to limit the dataset returned to stylists & stylist supervisors only (#92540)
11/18/2013 - DL - Updated procedure to reference the EmployeeHoursCertipay in HC_Accounting
03/06/2014 - DL - Join on EmployeePositionJoin table was causing data to be doubled in sales query. Replaced Join with temp table (#98582)
06/18/2014 - RH - (#103343) Added WHERE E.IsActiveFlag = 1 to the employee selection statement
06/19/2014 - RH - Commented out WHERE E.IsActiveFlag = 1 not to remove inactive employees from historical data.
09/19/2014 - DL - Joined on DimSalesOrderType table to exclude Write Off transactions (#105654)
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_LaborEfficiencySummary '6/14/2014', 'c'
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_LaborEfficiencySummary] (
	@PeriodEndDate SMALLDATETIME
,	@sType CHAR(1)
)AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @Date SMALLDATETIME
	,	@EndDate SMALLDATETIME
	,	@StartDate SMALLDATETIME
	,	@TrxStartDate SMALLDATETIME
	,	@PayGroup INT

	CREATE TABLE #Dates (
		DateID INT
	,	DateDescription VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)

	CREATE TABLE #Centers (
		CenterSSID INT
	)


	/********************************** Get list of centers *************************************/
	IF @sType='c'
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
			WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
				AND c.Active='Y'

			SET @PayGroup=1
		END
	ELSE IF @sType='f'
		BEGIN
			INSERT INTO #Centers
			SELECT c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion r
					ON c.RegionSSID = r.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType t
					ON c.CenterTypeKey = t.CenterTypeKey
			WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[78]%'
				AND c.Active='Y'

			SET @PayGroup=0
		END



	SET @Date = @PeriodEndDate

	SELECT @TrxStartDate = MAX(EndDate)
	FROM lkpPayPeriods
	WHERE PayGroup = @PayGroup
		AND EndDate <= @Date

	SET @EndDate = DATEADD(mi, -1, DATEADD(dd, 1, @TrxStartDate))

	SET @StartDate = DATEADD(dd, -41, @TrxStartDate)
	IF @StartDate < '01/01/2008'
		SET @StartDate = '01/01/2008'


	INSERT INTO #Dates (
		DateID
	,	DateDescription
	,	StartDate
	,	EndDate)
	SELECT 1
	,	'TwoWeeksBack'
	,	DATEADD(dd, -13, @TrxStartDate)
	,	@EndDate


	INSERT INTO #Dates (
		DateID
	,	DateDescription
	,	StartDate
	,	EndDate)
	SELECT 2
	,	'SixWeeksBack'
	,	DATEADD(dd, -41, @TrxStartDate)
	,	@EndDate


	-- Get Employees in appropriate positions only.  And WHERE E.IsActiveFlag = 1
	SELECT  EPJ.EmployeeGUID
	INTO	#EmployeePositions
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePositionJoin EPJ
		ON e.EmployeeSSID = epj.EmployeeGUID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployeePosition EP
		ON EPJ.EmployeePositionID = EP.EmployeePositionSSID
	WHERE   EPJ.EmployeePositionID IN ( 1, 29, 33 )
		--AND E.IsActiveFlag = 1


	--Get transactional information per employee
	SELECT R.RegionDescription
	,	C.CenterSSID AS 'CenterID'
	,	C.CenterDescriptionNumber
	,	E.EmployeeKey
	,	E.EmployeeFullName
	,	E.EmployeePayrollID AS 'EmployeeID'
	,	SUM(CASE WHEN #Dates.DateID=1 THEN 1 ELSE 0 END) AS 'TwoWeeksBack'
	,	CONVERT(DECIMAL(7, 2), ((SUM(CASE WHEN #Dates.DateID=1 AND CLT.GenderSSID=1 THEN 1 ELSE 0 END * CONVERT(DECIMAL(7, 2), LSD.MenDuration))
			+ SUM(CASE WHEN #Dates.DateID=1 AND CLT.GenderSSID=2 THEN 1 ELSE 0 END * CONVERT(DECIMAL(7, 2), LSD.WomenDuration))) / 60)) AS 'TwoWeeksBack_Hours'
	,	SUM(CASE WHEN #Dates.DateID=1 THEN 1 ELSE 0 END * ISNULL(SP.Points, 0)) AS 'TwoWeeksBack_Points'
	,	SUM(CASE WHEN #Dates.DateID=2 THEN 1 ELSE 0 END) AS 'SixWeeksBack'
	,	CONVERT(DECIMAL(7, 2), ((SUM(CASE WHEN #Dates.DateID=2 AND CLT.GenderSSID=1 THEN 1 ELSE 0 END * CONVERT(DECIMAL(7, 2), LSD.MenDuration))
			+ SUM(CASE WHEN #Dates.DateID=2 AND CLT.GenderSSID=2 THEN 1 ELSE 0 END * CONVERT(DECIMAL(7, 2), LSD.WomenDuration))) / 60)) AS 'SixWeeksBack_Hours'
	,	SUM(CASE WHEN #Dates.DateID=2 THEN 1 ELSE 0 END * ISNULL(SP.Points, 0)) AS 'SixWeeksBack_Points'
	INTO #Time
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = C.CenterKey
        INNER JOIN #Centers
            ON C.ReportingCenterSSID = #Centers.CenterSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
		INNER JOIN #Dates
			ON DD.FullDate BETWEEN #Dates.StartDate AND #Dates.EndDate
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType DSOT
			ON DSO.SalesOrderTypeKey = DSOT.SalesOrderTypeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
        LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
            ON FST.Employee2Key = E.EmployeeKey
		LEFT OUTER JOIN lkpLaborServiceDuration LSD
			ON SC.SalesCodeDescriptionShort = LSD.Code
		LEFT OUTER JOIN lkpStylistPoints SP
			ON FST.MembershipKey = SP.MembershipKey
	WHERE SC.SalesCodeTypeSSID=2  --Service
		AND SC.SalesCodeSSID NOT IN (706, 708)  --Refund Service, Service Write Off
		AND DSOT.SalesOrderTypeKey <> 5 ----NSF/Chargeback Order
		AND E.EmployeeSSID IN ( SELECT EP.EmployeeGUID FROM #EmployeePositions EP )
	GROUP BY R.RegionDescription
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	E.EmployeeKey
	,	E.EmployeeFullName
	,	E.EmployeePayrollID


	--Get employee hours
	SELECT t.RegionDescription
	,	t.CenterID
	,	t.CenterDescriptionNumber
	,	t.EmployeeKey
	,	t.EmployeeFullName
	,	t.EmployeeID
	,	CONVERT(INT, SUM(ISNULL(CASE WHEN EHC.PeriodEnd = @TrxStartDate THEN (EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000) ELSE 0 END, 0))) AS 'TwoWeeksBackTotal'
	,	CONVERT(INT, SUM(ISNULL(CASE WHEN EHC.PeriodEnd BETWEEN DATEADD(dd, -28, @TrxStartDate) and @TrxStartDate THEN (EHC.[SalaryHours] / 1000) + (EHC.[RegularHours] / 1000) + (ISNULL(EHC.TravelHours, 0) / 1000) ELSE 0 END, 0))) AS 'SixWeeksBackTotal'
	INTO #Hours
	FROM #Time t
		INNER JOIN [HC_Accounting].[dbo].[EmployeeHoursCertipay] EHC
			ON CONVERT(VARCHAR, t.EmployeeID) = CONVERT(VARCHAR, EHC.EmployeeID)
	WHERE EHC.PeriodEnd BETWEEN @StartDate and @EndDate
	GROUP BY t.RegionDescription
	,	t.CenterID
	,	t.CenterDescriptionNumber
	,	t.EmployeeKey
	,	t.EmployeeFullName
	,	t.EmployeeID



	--Get distinct clients for time period
	SELECT FST.ClientMembershipKey
	,	MAX(FST.SalesOrderDetailKey) AS 'SalesOrderDetailKey'
	INTO #Distinct
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.ReportingCenterSSID = #Centers.CenterSSID
	WHERE SC.SalesCodeTypeSSID=1
		AND DD.FullDate BETWEEN @StartDate and @EndDate
		AND M.MembershipSSID NOT IN (30, 31)
	GROUP BY FST.ClientMembershipKey


	--Get retail information per employee
	SELECT R.RegionDescription
	,	C.CenterSSID as 'CenterID'
	,	C.CenterDescriptionNumber
	,	E.EmployeeKey
	,	SUM(FST.ExtendedPrice) AS 'TotalRetail'
	,	SUM(ISNULL(SP.Points, 0)) AS 'TotalPoints'
	,	COUNT(1) AS 'DistinctClients'
	INTO #Retail
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN #Distinct D
			ON FST.SalesOrderDetailKey = D.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = R.RegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee2Key = E.EmployeeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
		LEFT OUTER JOIN lkpStylistPoints SP
			ON FST.MembershipKey = SP.MembershipKey
	GROUP BY R.RegionDescription
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	E.EmployeeKey
	ORDER BY C.CenterDescriptionNumber
	,	E.EmployeeKey


	SELECT t.RegionDescription AS 'Region'
	,	t.CenterID as 'CenterID'
	,	t.CenterDescriptionNumber AS 'Center'
	,	t.EmployeeFullName AS 'Name'
	,	t.EmployeeKey AS 'StylistID'
	,	ISNULL(CONVERT(INT, t.TwoWeeksBack), 0) AS 'TwoWeeksBack'
	,	ISNULL(t.TwoWeeksBack_Hours, 0) AS 'TwoWeeksBackHrs'
	,	ISNULL(CONVERT(INT, h.TwoWeeksBackTotal), 0) AS 'TwoWeeksBackTotal'
	,	CONVERT(DECIMAL(5, 1), (ISNULL((CONVERT(DECIMAL, t.TwoWeeksBack_Hours) / NULLIF(CONVERT(DECIMAL, h.TwoWeeksBackTotal), 0)), 0)) * 100) 'TwoWeeksBackEfficiency'
	,	ISNULL(t.TwoWeeksBack_Points, 0) AS 'TwoWeeksBackPoints'
	,	ISNULL(CONVERT(INT, t.SixWeeksBack), 0) AS 'SixWeeksBack'
	,	ISNULL(t.SixWeeksBack_Hours, 0) AS 'SixWeeksBackHrs'
	,	ISNULL(CONVERT(INT, h.SixWeeksBackTotal), 0) AS 'SixWeeksBackTotal'
	,	CONVERT(DECIMAL(5, 1), (ISNULL((CONVERT(DECIMAL, t.SixWeeksBack_Hours) / NULLIF(CONVERT(DECIMAL, h.SixWeeksBackTotal), 0)), 0)) * 100) 'SixWeeksBackEfficiency'
	,	ISNULL(t.SixWeeksBack_Points, 0) AS 'SixWeeksBackPoints'
	,	CONVERT(VARCHAR(12), @EndDate, 101) AS 'PeriodEndDate'
	,	ISNULL(r.TotalPoints, 0) AS 'DistinctPoints'
	,	ISNULL(r.TotalRetail, 0) AS 'TotalRetailFormatted'
	,	ISNULL(CONVERT(INT, r.DistinctClients), 0) AS 'Clients'

	FROM #Time t
		LEFT OUTER JOIN #Hours h
			ON t.EmployeeKey = h.EmployeeKey
			AND t.CenterID = h.CenterID
		LEFT OUTER JOIN #Retail r
			ON t.EmployeeKey = r.EmployeeKey
			AND t.CenterID = r.CenterID
	WHERE t.EmployeeKey <> -1
	ORDER BY t.RegionDescription
	,	t.CenterID
	,	t.CenterDescriptionNumber
	,	t.EmployeeFullName



END
