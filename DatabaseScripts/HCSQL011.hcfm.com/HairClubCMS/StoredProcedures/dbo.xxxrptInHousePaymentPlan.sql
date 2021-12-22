/* CreateDate: 10/03/2016 11:42:22.660 , ModifyDate: 06/21/2019 13:14:17.070 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				[rptInHousePaymentPlan]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
AUTHOR: 				Rachelen Hut
DATE IMPLEMENTED: 		10/03/2016
==============================================================================
DESCRIPTION:
==============================================================================
CHANGE HISTORY:
11/07/2016 - RH - Removed duplicates using ROW_NUMBER() OVER PARTITION BY
11/09/2016 - RH - Added ContractAmount, DownpaymentAmount, RemainingBalance, ARBalance
11/10/2016 - RH - Changed JOIN on datPaymentPlanJournal to a LEFT JOIN to pull cancelled clients; Added Status counts
01/10/2017 - RH - Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description (#132688)
==============================================================================
SAMPLE EXECUTION:
EXEC [rptInHousePaymentPlan] 'C', '10/1/2016','10/31/2016'
EXEC [rptInHousePaymentPlan] 'C', '10/1/2016','11/30/2016'
EXEC [rptInHousePaymentPlan] 'C', '11/1/2016','11/30/2016'
==============================================================================
*/

CREATE PROCEDURE [dbo].[xxxrptInHousePaymentPlan](
	@Type NVARCHAR(1)
,	@StartDate DATETIME
,	@EndDate DATETIME
)

AS
BEGIN

SET NOCOUNT ON



/********************************** Create temp tables **************************************/

CREATE TABLE #Centers( RegionID INT
,		RegionDescription NVARCHAR(50)
,		CenterManagementAreaID INT
,		CenterManagementAreaDescription NVARCHAR(50)
,		CenterID INT
,		CenterDescription NVARCHAR(50)
,		RegionSortOrder INT
,		AreaManagerSortOrder INT
)


/********************************** Get list of centers *************************************/

IF @Type = 'C'  --Corporate
	BEGIN
		INSERT  INTO #Centers
				SELECT  R.RegionID
				,		R.RegionDescription
				,		AM.CenterManagementAreaID
				,		AM.CenterManagementAreaDescription
				,		C.CenterID
				,		C.CenterDescription
				,		R.RegionSortOrder
				,		AM.CenterManagementAreaSortOrder AS 'AreaManagerSortOrder'
				FROM    cfgCenter C
					INNER JOIN lkpRegion R
						ON C.RegionID = R.RegionID
					INNER JOIN dbo.vw_AreaManager AM
						ON C.CenterID = AM.CenterID
				WHERE	CONVERT(VARCHAR, C.CenterID) LIKE '[2]%'
						AND C.IsActiveFlag = 1
	END


IF @Type = 'F'  --Franchises
	BEGIN
		INSERT  INTO #Centers
				SELECT  R.RegionID
				,		R.RegionDescription
				,		NULL AS CenterManagementAreaID
				,		NULL AS CenterManagementAreaDescription
				,		C.CenterID
				,		C.CenterDescription
				,		R.RegionSortOrder
				,		NULL AS AreaManagerSortOrder
				FROM    cfgCenter C
					INNER JOIN lkpRegion R
						ON C.RegionID = R.RegionID
				WHERE	CONVERT(VARCHAR, C.CenterID) LIKE '[78]%'
						AND C.IsActiveFlag = 1
	END

/********************************** Get consultations *************************************/

SELECT C.CenterID
	,	SUM(CASE WHEN Consultation = 1 THEN 1 ELSE 0 END) AS 'Consultations'
INTO #Consultations
FROM    [dbo].[HC_BI_MKTG_DDS_vwFactActivityResults_VIEW] FAR
		INNER JOIN [dbo].[HC_BI_ENT_DDS_DimCenter_TABLE] DC
			ON FAR.CenterKey = DC.CenterKey
		INNER JOIN [dbo].[HC_BI_ENT_DDS_DimDate_TABLE] DD
			ON FAR.ActivityDueDateKey = DD.DateKey
		INNER JOIN #Centers C
			ON DC.CenterSSID = C.CenterID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND FAR.BeBack <> 1
	AND FAR.Show=1
GROUP BY C.CenterID

/********************** Find Net Sale Qty ****************************************************/

SELECT C.CenterID
,	SUM(ISNULL(FST.NB_TradCnt, 0))
				+ SUM(ISNULL(FST.NB_ExtCnt, 0))
				+ SUM(ISNULL(FST.NB_XtrCnt, 0))
                + SUM(ISNULL(FST.NB_GradCnt, 0))
				+ SUM(ISNULL(FST.S_SurCnt, 0))
                + SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Count'
INTO #Sales
FROM [dbo].[HC_BI_CMS_DDS_FactSalesTransaction_TABLE] FST
	INNER JOIN [dbo].[HC_BI_ENT_DDS_DimDate_TABLE] DD
	        ON FST.OrderDateKey = DD.DateKey
	INNER JOIN [dbo].[HC_BI_ENT_DDS_DimCenter_TABLE] DC
			ON FST.CenterKey = DC.CenterKey
	INNER JOIN #Centers C
			ON DC.CenterSSID = C.CenterID
	INNER JOIN [dbo].[HC_BI_CMS_DDS_DimSalesCode_TABLE] SC
            ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN [dbo].[HC_BI_CMS_DDS_DimSalesOrder_TABLE] SO
			ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN [dbo].[HC_BI_CMS_DDS_DimSalesOrderDetail_TABLE] SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
                AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
                AND SOD.IsVoidedFlag = 0
GROUP BY C.CenterID

/************************** Find those on a Payment Plan ***************************************/

SELECT CLT.CenterID
,	C.CenterDescription
,	C.RegionID
,	C.RegionDescription
,	C.CenterManagementAreaID
,	C.CenterManagementAreaDescription
,	CLT.ClientIdentifier
,	PP.ContractAmount
,	PP.DownpaymentAmount
,	PP.RemainingBalance
,	CLT.ARBalance
,	PPS.PaymentPlanStatusDescription
,	PP.StartDate
,	ROW_NUMBER() OVER (PARTITION BY CLT.ClientIdentifier ORDER BY PP.RemainingNumberOfPayments ASC) AS 'Ranking'
INTO #PaymentPlan
FROM dbo.datPaymentPlan PP
	INNER JOIN dbo.datClient CLT
		ON PP.ClientGUID = CLT.ClientGUID
	INNER JOIN #Centers C
		ON CLT.CenterID = C.CenterID
	LEFT JOIN dbo.datPaymentPlanJournal PPJ
		ON PP.PaymentPlanID = PPJ.PaymentPlanID
	INNER JOIN lkpPaymentPlanStatus PPS
		ON PP.PaymentPlanStatusID = PPS.PaymentPlanStatusID

/**************************** Final select *****************************************************/

SELECT C.CenterID
,	C.CenterDescription
,	C.RegionID
,	C.RegionDescription
,	C.CenterManagementAreaID
,	C.CenterManagementAreaDescription
,	COUNT(PPlan.ClientIdentifier) AS 'PaymentPlanQuantity'
,	SUM(ISNULL(CASE WHEN PPlan.PaymentPlanStatusDescription = 'Active' AND PPlan.StartDate BETWEEN @StartDate AND @EndDate THEN 1 ELSE 0 END,0))  AS 'NBCount'
,	SUM(ISNULL(CASE WHEN PPlan.PaymentPlanStatusDescription = 'Cancelled' THEN 1 ELSE 0 END,0))  AS 'CancelCount'
,	SUM(ISNULL(CASE WHEN PPlan.PaymentPlanStatusDescription = 'Paid' THEN 1 ELSE 0 END,0)) AS 'PaidCount'
,	SUM(ISNULL(PPlan.ContractAmount,0)) AS 'ContractAmount'
,	SUM(ISNULL(PPlan.DownpaymentAmount,0)) AS 'DownpaymentAmount'
,	SUM(ISNULL(PPlan.RemainingBalance,0)) AS 'RemainingBalance'
,	SUM(ISNULL(PPlan.ARBalance,0)) AS 'ARBalance'
,	S.NetNB1Count
,	Cons.Consultations
,	dbo.fxDivideDecimal(ISNULL(S.NetNB1Count, 0), ISNULL(Cons.Consultations, 0)) AS 'ClosePercent'
FROM #Centers C
	LEFT OUTER JOIN #Sales S
		ON C.CenterID = S.CenterID
	LEFT OUTER JOIN #Consultations Cons
		ON C.CenterID = Cons.CenterID
	LEFT OUTER JOIN #PaymentPlan PPlan
		ON C.CenterID = PPlan.CenterID
WHERE PPlan.Ranking = 1
GROUP BY dbo.fxDivideDecimal(ISNULL(S.NetNB1Count,0), ISNULL(Cons.Consultations ,0))
       , C.CenterID
       , C.CenterDescription
       , C.RegionID
       , C.RegionDescription
       , C.CenterManagementAreaID
       , C.CenterManagementAreaDescription
       , S.NetNB1Count
	   , Cons.Consultations

END
GO
