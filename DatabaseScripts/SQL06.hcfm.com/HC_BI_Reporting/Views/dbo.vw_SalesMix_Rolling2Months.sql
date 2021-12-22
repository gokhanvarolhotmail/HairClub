/* CreateDate: 11/07/2018 15:19:17.187 , ModifyDate: 11/07/2018 15:20:36.573 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vw_SalesMix_Rolling2Months]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		11/07/2018
------------------------------------------------------------------------
NOTES: This view is being used to populate the PBI report New Business
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vw_SalesMix_Rolling2Months] where CenterNumber = 201 order by FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vw_SalesMix_Rolling2Months]
AS

--Find dates for Rolling 2 Months

WITH Rolling2Months AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(MONTH,-2,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)) --First Day of two months ago
					AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --Today at 11:59PM
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
		)



SELECT  DC.CenterNumber
	,       DD.FirstDateOfMonth --Always first of the month
	--SALES
	,   SUM(ISNULL(FST.NB_TradCnt, 0))		Trad
	,	SUM(ISNULL(FST.NB_GradCnt, 0))		Grad
	,	SUM(ISNULL(FST.NB_ExtCnt, 0))		EXT
	,	SUM(ISNULL(FST.S_PostExtCnt, 0))	PostEXT
	,	SUM(ISNULL(FST.S_SurCnt, 0))		Surgery
	,	SUM(ISNULL(FST.NB_XTRCnt, 0))		Xtrands
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
	WHERE  CT.CenterTypeDescriptionShort IN('C','F','JV')
		AND DC.Active = 'Y'
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND DSOD.IsVoidedFlag = 0
	GROUP BY DC.CenterNumber
	,       DD.FirstDateOfMonth
GO
