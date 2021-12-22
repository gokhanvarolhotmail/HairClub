/*==============================================================================
PROCEDURE:					sprpt_FeeCenterReport
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/22/2012
-- Date Implemented:       8/22/2012
-- Date Last Modified:     8/22/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
==============================================================================
DESCRIPTION:	Report that Displays Fee Center Breakdown by Centers
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_FeeCenterReport 1,2008
==============================================================================*/
CREATE PROCEDURE [dbo].[sprpt_FeeCenterReport]
      @Month    TINYINT
,     @Year     SMALLINT
AS

BEGIN
	--SET FMTONLY OFF
	DECLARE @startDate DATETIME
	DECLARE @mynum INT
	SET @startDate = RTRIM(@Month) + '/01/' + RTRIM(@Year)

	DECLARE @MONTH1 DATETIME =  @startDate
	,@MONTH2 DATETIME = DATEADD(M, -1, @startDate)
	,@MONTH3 DATETIME = DATEADD(M, -2, @startDate)
	,@MONTH4 DATETIME = DATEADD(M, -3, @startDate)

	DECLARE @TempDate DATETIME

	,	@CurrentMonthStart DATETIME
	,	@CurrentMonthEnd DATETIME

	,	@OneMonthBackStart DATETIME
	,	@OneMonthBackEnd DATETIME

	,	@TwoMonthsBackStart DATETIME
	,	@TwoMonthsBackEnd DATETIME

	,	@ThreeMonthsBackStart DATETIME
	,	@ThreeMonthsBackEnd DATETIME

	SELECT @CurrentMonthStart = CAST(CONVERT(VARCHAR(2), @Month) + '/1/' + CONVERT(VARCHAR(4), @Year) AS DATETIME)
	,	@CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

	,	@OneMonthBackStart = DATEADD(MONTH, -1, @CurrentMonthStart)
	,	@OneMonthBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @OneMonthBackStart))

	,	@TwoMonthsBackStart = DATEADD(MONTH, -2, @CurrentMonthStart)
	,	@TwoMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @TwoMonthsBackStart))

	,	@ThreeMonthsBackStart = DATEADD(MONTH, -3, @CurrentMonthStart)
	,	@ThreeMonthsBackEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @ThreeMonthsBackStart))

	DECLARE @Data TABLE(
		Center_No INT
	,	Center VARCHAR(200)
	,	Region VARCHAR(200)
	,	DateMonth VARCHAR(50)
	,	StartDate DATETIME
	,	SumPriceM1 MONEY
	,	RecordCountM1 INT
	,	SumPriceM2 MONEY
	,	RecordCountM2 INT
	,	SumPriceM3 MONEY
	,	RecordCountM3 INT
	,	SumPriceM4 MONEY
	,	RecordCountM4 INT
	,	SumPriceM5 MONEY
	,	RecordCountM5 INT
	)

	DECLARE @Dates TABLE (
		DateID INT
	,	DateMonthDesc VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)

	INSERT INTO @Dates(DateID, DateMonthDesc, StartDate, EndDate)
	VALUES (1, DATENAME(MONTH,@CurrentMonthStart), @CurrentMonthStart, @CurrentMonthEnd)

	INSERT INTO @Dates(DateID, DateMonthDesc, StartDate, EndDate)
	VALUES (2, DATENAME(MONTH,@OneMonthBackStart), @OneMonthBackStart, @OneMonthBackEnd)

	INSERT INTO @Dates(DateID, DateMonthDesc, StartDate, EndDate)
	VALUES (3, DATENAME(MONTH,@TwoMonthsBackStart), @TwoMonthsBackStart, @TwoMonthsBackEnd)

	INSERT INTO @Dates(DateID, DateMonthDesc, StartDate, EndDate)
	VALUES (4, DATENAME(MONTH,@ThreeMonthsBackStart), @ThreeMonthsBackStart, @ThreeMonthsBackEnd)

	DECLARE @Centers TABLE (
		CenterKey INT
	,	Center_No INT
	,	Center VARCHAR(200)
	,	Region VARCHAR(200)
	)

	INSERT INTO @Centers
	SELECT CenterKey, CenterSSID, ce.CenterDescriptionNumber, re.RegionDescription
	FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = ce.RegionKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
	WHERE ce.CenterSSID LIKE '2%' AND ce.Active = 'Y'

	SELECT
	c.Center_No AS Center_No
	,c.Center AS Center
	,c.Region AS Region
	,dd.DateMonthDesc AS DateMonth
	,dd.StartDate As StartDate
	,t.Price
	,sc.SalesCodeSSID
	INTO #TEMP
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
		ON d.DateKey = t.OrderDateKey
		AND d.FullDate BETWEEN  @ThreeMonthsBackStart AND @CurrentMonthEnd
		INNER JOIN @Dates dd
			ON d.FullDate BETWEEN dd.StartDate and dd.EndDate
	INNER JOIN @Centers c
		ON c.CenterKey = t.CenterKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc
		ON sc.SalesCodeKey = t.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so
		ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m
		ON m.MembershipKey = t.MembershipKey
	WHERE t.price <> 0
		AND m.RevenueGroupSSID = 2

		AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPT')
		AND sc.SalesCodeDepartmentSSID IN (2020)

	INSERT INTO @Data(Center_No,Center,Region,DateMonth,StartDate,SumPriceM1,RecordCountM1)
	SELECT Center_No,Center,Region,DateMonth,StartDate
	,Sum(Price) SumPriceM1
	,SUM(CASE
		WHEN Price = 0 AND SalesCodeSSID IN (677,678) THEN 1
		WHEN Price <> 0 THEN 1
		ELSE 0
	END) AS 'RecordCountM'
	FROM #TEMP
	WHERE StartDate = @CurrentMonthStart
	GROUP BY Center_No,Center,Region,DateMonth,StartDate

	INSERT INTO @Data(Center_No,Center,Region,DateMonth,StartDate,SumPriceM2,RecordCountM2)
	SELECT Center_No,Center,Region,DateMonth,StartDate
	,Sum(Price) SumPriceM1
	,SUM(CASE
		WHEN Price = 0 AND SalesCodeSSID IN (677,678) THEN 1
		WHEN Price <> 0 THEN 1
		ELSE 0
	END) AS 'RecordCountM'
	FROM #TEMP
	WHERE StartDate = @CurrentMonthStart
	GROUP BY Center_No,Center,Region,DateMonth,StartDate

	INSERT INTO @Data(Center_No,Center,Region,DateMonth,StartDate,SumPriceM3,RecordCountM3)
	SELECT Center_No,Center,Region,DateMonth,StartDate
	,Sum(Price) SumPriceM1
	,SUM(CASE
		WHEN Price = 0 AND SalesCodeSSID IN (677,678) THEN 1
		WHEN Price <> 0 THEN 1
		ELSE 0
	END) AS 'RecordCountM'
	FROM #TEMP
	WHERE StartDate = @CurrentMonthStart
	GROUP BY Center_No,Center,Region,DateMonth,StartDate

	INSERT INTO @Data(Center_No,Center,Region,DateMonth,StartDate,SumPriceM4,RecordCountM4)
	SELECT Center_No,Center,Region,DateMonth,StartDate
	,Sum(Price) SumPriceM1
	,SUM(CASE
		WHEN Price = 0 AND SalesCodeSSID IN (677,678) THEN 1
		WHEN Price <> 0 THEN 1
		ELSE 0
	END) AS 'RecordCountM'
	FROM #TEMP
	WHERE StartDate = @CurrentMonthStart
	GROUP BY Center_No,Center,Region,DateMonth,StartDate


	SELECT
	Center_No,Center,Region,DateMonth,StartDate
	,ISNULL(SumPriceM1,0) SumPriceM1
	,ISNULL(RecordCountM1,0) RecordCountM1
	,ISNULL(SumPriceM2,0) SumPriceM2
	,ISNULL(RecordCountM2,0) RecordCountM2
	,ISNULL(SumPriceM3,0) SumPriceM3
	,ISNULL(RecordCountM3,0) RecordCountM3
	,ISNULL(SumPriceM4,0) SumPriceM4
	,ISNULL(RecordCountM4,0) RecordCountM4
	,ISNULL(SumPriceM5,0) SumPriceM5
	,ISNULL(RecordCountM5,0) RecordCountM5
	FROM @Data
	ORDER BY Center, DateMonth

	DROP TABLE #TEMP

END
