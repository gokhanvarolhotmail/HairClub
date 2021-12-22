/* CreateDate: 09/08/2015 14:54:00.000 , ModifyDate: 01/26/2018 16:13:18.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_ActualByCenter_Rolling2Months
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			09/01/2015
------------------------------------------------------------------------
CHANGE HISTORY:
09/10/2015 - RH - Removed PostEXT from the NetNB1SalesCnt and the NetNB1SalesAmt
01/26/2018 - RH - Added CenterType (#145957)
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_ActualByCenter_Rolling2Months
***********************************************************************/
CREATE VIEW [dbo].[vwd_ActualByCenter_Rolling2Months]
AS

WITH Rolling2Months AS (
				SELECT	DD.FirstDateOfMonth  --Budgets are monthly
				,	DD.DateKey
				,	DD.MonthNumber
				,	DD.YearNumber
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.FirstDateOfMonth
                       , DD.DateKey
                       , DD.MonthNumber
                       , DD.YearNumber
		)
,	Actuals AS (SELECT DC.CenterSSID
				,	DD.FirstDateOfMonth
				,   SUM(ISNULL(FST.NB_TradCnt, 0))AS 'NB_TradCnt'
				,	SUM(ISNULL(FST.NB_ExtCnt, 0))AS 'NB_ExtCnt'
				,	SUM(ISNULL(FST.NB_XTRCnt, 0))AS 'NB_XTRCnt'
				,	SUM(ISNULL(FST.NB_GradCnt, 0))AS 'NB_GradCnt'
				,	SUM(ISNULL(FST.S_SurCnt, 0)) AS 'S_SurCnt'
				,	SUM(ISNULL(FST.S_PostExtCnt, 0)) AS 'S_PostExtCnt'
				,   SUM(ISNULL(FST.NB_TradCnt, 0)) + SUM(ISNULL(FST.NB_ExtCnt, 0)) + SUM(ISNULL(FST.NB_XTRCnt, 0)) + SUM(ISNULL(FST.NB_GradCnt, 0))
						+ SUM(ISNULL(FST.S_SurCnt, 0))  AS 'NetNB1SalesCnt'

				,   SUM(ISNULL(FST.NB_TradAmt, 0))AS 'NB_TradAmt'
				,	SUM(ISNULL(FST.NB_ExtAmt, 0))AS 'NB_ExtAmt'
				,	SUM(ISNULL(FST.NB_XTRAmt, 0))AS 'NB_XTRAmt'
				,	SUM(ISNULL(FST.NB_GradAmt, 0))AS 'NB_GradAmt'
				,	SUM(ISNULL(FST.S_SurAmt, 0)) AS 'S_SurAmt'
				,	SUM(ISNULL(FST.S_PostExtAmt, 0)) AS 'S_PostExtAmt'
				,   SUM(ISNULL(FST.NB_TradAmt, 0)) + SUM(ISNULL(FST.NB_ExtAmt, 0)) + SUM(ISNULL(FST.NB_XTRAmt, 0)) + SUM(ISNULL(FST.NB_GradAmt, 0))
						+ SUM(ISNULL(FST.S_SurAmt, 0)) AS 'NetNB1SalesAmt'

				FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
						INNER JOIN Rolling2Months DD
							ON FST.OrderDateKey = DD.DateKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
							ON DSC.SalesCodeKey = FST.SalesCodeKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
							ON DSO.SalesOrderKey = FST.SalesOrderKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
							ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
							ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
							ON DM.MembershipKey = DCM.MembershipKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
							ON DC.CenterKey = DCM.CenterKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
				WHERE  CT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
						AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
						AND DSOD.IsVoidedFlag = 0
				GROUP BY DC.CenterSSID
                       , DD.FirstDateOfMonth
		)




SELECT A.CenterSSID
		,	ROLL.FirstDateOfMonth
		,	ROLL.MonthNumber
		,	ROLL.YearNumber
		,	ISNULL(A.NetNB1SalesCnt,0) AS 'Total NB Sales'
		,	ISNULL(A.NB_TradCnt,0) AS 'Trad NB Sales'
		,	ISNULL(A.NB_ExtCnt,0) AS 'EXT NB Sales'
		,	ISNULL(A.NB_XTRCnt,0) AS 'XTR NB Sales'
		,	ISNULL(A.NB_GradCnt,0) AS 'Grad NB Sales'
		,	ISNULL(A.S_SurCnt,0) AS 'SUR NB Sales'
		,	ISNULL(A.S_PostExtCnt,0) AS 'PostEXT NB Sales'

		,	ROUND(ISNULL(A.NetNB1SalesAmt,0),0) AS 'Total NB Revenue'
		,	ROUND(ISNULL(A.NB_TradAmt,0),0) AS 'Trad NB Revenue'
		,	ROUND(ISNULL(A.NB_ExtAmt,0),0) AS 'EXT NB Revenue'
		,	ROUND(ISNULL(A.NB_XTRAmt,0),0) AS 'XTR NB Revenue'
		,	ROUND(ISNULL(A.NB_GradAmt,0),0) AS 'Grad NB Revenue'
		,	ROUND(ISNULL(A.S_SurAmt,0),0) AS 'SUR NB Revenue'
		,	ROUND(ISNULL(A.S_PostExtAmt,0),0) AS 'PostEXT NB Revenue'

FROM Actuals A
INNER JOIN Rolling2Months ROLL
	ON A.FirstDateOfMonth = ROLL.FirstDateOfMonth
GROUP BY ISNULL(A.NetNB1SalesCnt ,0)
       , ISNULL(A.NB_TradCnt ,0)
       , ISNULL(A.NB_ExtCnt ,0)
       , ISNULL(A.NB_XTRCnt ,0)
       , ISNULL(A.NB_GradCnt ,0)
       , ISNULL(A.S_SurCnt ,0)
       , ISNULL(A.S_PostExtCnt ,0)
       , ROUND(ISNULL(A.NetNB1SalesAmt ,0) ,0)
       , ROUND(ISNULL(A.NB_TradAmt ,0) ,0)
       , ROUND(ISNULL(A.NB_ExtAmt ,0) ,0)
       , ROUND(ISNULL(A.NB_XTRAmt ,0) ,0)
       , ROUND(ISNULL(A.NB_GradAmt ,0) ,0)
       , ROUND(ISNULL(A.S_SurAmt ,0) ,0)
       , ROUND(ISNULL(A.S_PostExtAmt ,0) ,0)
       , A.CenterSSID
       , ROLL.FirstDateOfMonth
       , ROLL.MonthNumber
       , ROLL.YearNumber
GO
