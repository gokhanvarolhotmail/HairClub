/***********************************************************************
PROCEDURE:				[spRpt_WarBoardCSC]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			[spRpt_WarBoardCSC]
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		07/17/2019
------------------------------------------------------------------------
NOTES:


------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_WarBoardCSC] 6,2019


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_WarBoardCSC]
(
	@Month INT
,	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;

/************** Declare and set variables ********************************************************/

DECLARE @StartDate DATE
DECLARE	@EndDate DATE
DECLARE @BeginningOfTheYear DATE

SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
SET @EndDate = DATEADD(day, -1* day(dateadd(month, 1 ,@StartDate)),dateadd(month, 1 , @StartDate))
SET @BeginningOfTheYear = CAST('1/1/' + DATENAME(YEAR,@StartDate) AS DATE)

--If @EndDate is this month, then pull yesterday's date, because FactReceivables populates once a day at 3:00 AM
DECLARE @ReceivablesDate DATETIME

IF MONTH(@EndDate) = MONTH(GETDATE())
BEGIN
	SET @ReceivablesDate = CONVERT(VARCHAR(11), DATEADD(dd, -1, GETDATE()), 101) --Yesterday
END
ELSE
BEGIN
	SET @ReceivablesDate = @EndDate
END

PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(120))
PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(120))
PRINT '@BeginningOfTheYear = ' + CAST(@BeginningOfTheYear AS NVARCHAR(120))
PRINT '@ReceivablesDate = ' + CAST(@ReceivablesDate AS NVARCHAR(120))


/************ Create temp tables *****************************************************************/

CREATE TABLE #Centers (
	CenterNumber INT
,	CenterDescriptionNumber VARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription VARCHAR(50)
,	RecurringBusinessSize NVARCHAR(10)
)

CREATE TABLE #Receivable(
	CenterNumber INT
,	Receivable DECIMAL(18,4)
)


CREATE TABLE #CtrRetailSales(
	CenterNumber INT
,	CtrRetailSales DECIMAL(18,4)
)


/********************************** Find center information   *************************************/

INSERT INTO #Centers
SELECT c.CenterNumber
,	c.CenterDescriptionNumber
,   CMA.CenterManagementAreaSSID
,   CMA.CenterManagementAreaDescription
,	c.RecurringBusinessSize
FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
		ON	CT.CenterTypeKey = C.CenterTypeKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
		ON C.CenterManagementAreaSSID = CMA. CenterManagementAreaSSID
WHERE	CT.CenterTypeDescriptionShort IN('C')
		AND C.Active = 'Y'
		AND C.CenterNumber NOT IN(100,199)


/********************************** Get Receivables *************************************/


INSERT INTO #Receivable
SELECT CenterNumber
,	SUM(Balance) AS 'Receivable'
FROM
	(SELECT  C.CenterNumber
		,   CLT.ClientIdentifier
		,	CLT.ClientKey
		,   CM.ClientMembershipKey
		,	FR.Balance AS 'Balance'
		,	ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY CM.ClientMembershipEndDate DESC) AS Ranking
	FROM    HC_Accounting.dbo.FactReceivables FR
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FR.DateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FR.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FR.CenterKey = C.CenterKey
			INNER JOIN #Centers CTR
				ON C.CenterNumber = CTR.CenterNumber
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
				ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
					OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON CM.MembershipSSID = M.MembershipSSID
	WHERE   DD.FullDate = @ReceivablesDate
		AND M.RevenueGroupSSID = 2
		AND FR.Balance >= 0
		) b
WHERE Ranking = 1
GROUP BY CenterNumber


/**********Find Retail sales per center per timeframe ***************************/


INSERT  INTO #CtrRetailSales
        SELECT  C.CenterNumber
		,	SUM(ISNULL(FST.RetailAmt, 0)) AS 'CtrRetailSales'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d
			ON d.DateKey = FST.OrderDateKey
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesOrderDetail sod
			ON FST.salesorderdetailkey = sod.SalesOrderDetailKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON FST.CenterKey = c.CenterKey
		INNER JOIN #Centers CTR
            ON c.CenterNumber = CTR.CenterNumber
		INNER JOIN hc_bi_cms_dds.bi_cms_dds.DimSalesCode sc
			ON FST.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment scd
			ON sc.SalesCodeDepartmentKey = scd.SalesCodeDepartmentKey
		WHERE   d.FullDate BETWEEN @StartDate AND @EndDate
				AND (SCD.SalesCodeDivisionSSID IN ( 30, 50 ) AND SC.SalesCodeDepartmentSSID <> 3065)
		GROUP BY C.CenterNumber


/*********** Final select***********************************************/

SELECT C.RecurringBusinessSize
,	C.CenterNumber
,	C.CenterManagementAreaSSID
,	C.CenterManagementAreaDescription
,	C.CenterDescriptionNumber
,	ISNULL(R.Receivable,0) AS Receivable
,	ISNULL(RS.CtrRetailSales,0) AS CtrRetailSales
,	@StartDate AS StartDate
,	@EndDate AS EndDate
FROM #Centers C
	LEFT JOIN #Receivable R
		ON C.CenterNumber = R.CenterNumber
	LEFT JOIN #CtrRetailSales RS
		ON C.CenterNumber = RS.CenterNumber



END
