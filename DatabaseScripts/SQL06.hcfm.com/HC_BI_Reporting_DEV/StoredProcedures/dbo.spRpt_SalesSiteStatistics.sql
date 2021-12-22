/* CreateDate: 11/28/2012 09:49:04.023 , ModifyDate: 04/08/2013 10:06:14.870 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				spRpt_SalesSiteStatistics

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		11/27/2012

==============================================================================
DESCRIPTION:	Company tatistics for sales department site
==============================================================================
NOTES:

--  04/08/2013 - KM - Modified to derive Factaccounting from HC_Accounting
==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_SalesSiteStatistics 1, 0
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_SalesSiteStatistics] (
	@Filter INT
,	@RegionSSID INT
)
AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF

	DECLARE @YesterdayStart DATETIME
	,	@YesterdayEnd DATETIME
	,	@CurrentMonthStart DATETIME
	,	@CurrentMonthEnd DATETIME
	,	@CurrentYearStart DATETIME
	,	@CurrentYearEnd DATETIME
	,	@PriorWeekStart DATETIME
	,	@PriorWeekEnd DATETIME


	CREATE TABLE #Centers (
		CenterDescription VARCHAR(50)
	,	CenterID INT
	)

	CREATE TABLE #Dates (
		DateID INT
	,	DateDesc VARCHAR(50)
	,	StartDate DATETIME
	,	EndDate DATETIME
	)


	IF @RegionSSID=0
		BEGIN
			INSERT INTO #Centers (
				CenterDescription
			,	CenterID
			)
			SELECT 'All Corporate Centers'
			,	c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			WHERE CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
		END
	ELSE
		BEGIN
			INSERT INTO #Centers (
				CenterDescription
			,	CenterID
			)
			SELECT R.RegionDescription
			,	c.CenterSSID
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = r.RegionKey
			WHERE R.RegionSSID=@RegionSSID
				AND CONVERT(VARCHAR, c.CenterSSID) LIKE '[2]%'
		END


	SET @YesterdayStart = CONVERT(DATETIME, CONVERT(VARCHAR, DATEADD(DAY, -1, GETDATE()), 101))
	SET @YesterdayEnd = @YesterdayStart

	SET @PriorWeekStart = CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE() - DATEPART(dw, GETDATE()) - 6, 101))
	SET @PriorWeekEnd = GETDATE() - DATEPART(dw, GETDATE())

	SET @CurrentMonthStart = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@YesterdayStart)) + '/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
	SET @CurrentMonthEnd = DATEADD(MINUTE, -1, DATEADD(MONTH, 1, @CurrentMonthStart))

	SET @CurrentYearStart = CONVERT(DATETIME, '1/1/' + CONVERT(VARCHAR, YEAR(@YesterdayStart)))
	SET @CurrentYearEnd = DATEADD(MINUTE, -1, DATEADD(YEAR, 1, @CurrentYearStart))


	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (1, 'Current Month ( ' + CONVERT(VARCHAR, @CurrentMonthStart, 101) + ' - ' + CONVERT(VARCHAR, GETDATE(), 101) + ' )', @CurrentMonthStart, @CurrentMonthEnd)

	INSERT INTO #Dates(DateID, DateDesc, StartDate, EndDate)
	VALUES (2, 'Current Year ( ' + CONVERT(VARCHAR, @CurrentYearStart, 101) + ' - ' + CONVERT(VARCHAR, GETDATE(), 101) + ' )', @CurrentYearStart, @CurrentYearEnd)


	SELECT C.CenterDescription
	,	D.DateDesc
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10210, 10215, 10220, 10225) THEN Flash ELSE 0 END, 0)) AS 'NetNb1CountActual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10205, 10210, 10215, 10220, 10225) THEN Budget ELSE 0 END, 0)) AS 'NetNb1CountBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Flash ELSE 0 END, 0)) AS 'NetNb1AmountActual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10305, 10315, 10310, 10320, 10325) THEN Budget ELSE 0 END, 0)) AS 'NetNb1AmountBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Flash ELSE 0 END, 0)) AS 'ApplicationsActual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10240) THEN Budget ELSE 0 END, 0)) AS 'ApplicationsBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Flash ELSE 0 END, 0)) AS 'BIOConversionsActual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10430) THEN Budget ELSE 0 END, 0)) AS 'BIOConversionsBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Flash ELSE 0 END, 0)) AS 'EXTConversionsActual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10435) THEN Budget ELSE 0 END, 0)) AS 'EXTConversionsBudget'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10530) THEN Flash ELSE 0 END, 0)) AS 'PCPRevenueActual'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10530, 10535) THEN Budget ELSE 0 END, 0)) AS 'PCPRevenueBudget'
	FROM HC_Accounting.[dbo].[FactAccounting] FA
		INNER JOIN #Centers C
			ON FA.CenterID = C.CenterID
		INNER JOIN #Dates D
			ON FA.PartitionDate BETWEEN D.StartDate AND D.EndDate
	WHERE FA.AccountID IN (10205, 10210, 10215, 10220, 10225, 10305, 10315, 10310, 10320, 10325, 10240, 10430, 10435, 10530, 10535)
		AND D.DateID = @Filter
	GROUP BY C.CenterDescription
	,	D.DateDesc
END
GO
