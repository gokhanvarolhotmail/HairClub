/* CreateDate: 11/07/2018 15:33:31.523 , ModifyDate: 03/19/2019 15:14:07.213 */
GO
/***********************************************************************
VIEW:					[vw_SalesMix_YearToDate]
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

SELECT * FROM [vw_SalesMix_YearToDate] where CenterNumber = 201 order by FirstDateOfMonth
***********************************************************************/
CREATE VIEW [dbo].[vw_SalesMix_YearToDate]
AS

--Find dates for Year to Date

WITH YearToDate AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				,	DD.FirstDateOfMonth
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN CAST('1/1/' + DATENAME(YEAR,GETDATE()) AS DATE)
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
	,   SUM(ISNULL(FST.NB_TradCnt, 0))	+ SUM(ISNULL(FST.NB_GradCnt, 0))	XP
	,	SUM(ISNULL(FST.NB_ExtCnt, 0))	+ SUM(ISNULL(FST.S_PostExtCnt, 0))	EXT
	,	SUM(ISNULL(FST.S_SurCnt, 0))		SUR
	,	SUM(ISNULL(FST.NB_XTRCnt, 0))		XTR
	,	SUM(ISNULL(FST.NB_MDPCnt, 0))			MDP
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN YearToDate DD
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
