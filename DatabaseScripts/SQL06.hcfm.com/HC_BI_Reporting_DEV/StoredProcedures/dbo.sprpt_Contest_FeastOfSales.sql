/* CreateDate: 10/23/2012 14:15:05.787 , ModifyDate: 11/19/2012 11:16:43.867 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				sprpt_Contest_FeastOfSales

VERSION:				v1.0

DESTINATION SERVER:		HCDEVSQL2

DESTINATION DATABASE: 	BOSOPERATIONS

RELATED APPLICATION:  	Executive Query Only

AUTHOR: 				James Hannah III

IMPLEMENTOR: 			HDu

DATE IMPLEMENTED:		7/14/2008

LAST REVISION DATE: 	7/14/2008

==============================================================================
DESCRIPTION:	Report that Displays Feast of Sales Holiday Contest
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC sprpt_Contest_FeastOfSales '10/26/12', '12/7/12'
==============================================================================
*/
CREATE  PROCEDURE [dbo].[sprpt_Contest_FeastOfSales] ( @begdt smalldatetime, @enddt smalldatetime) AS
	SET NOCOUNT ON
SET FMTONLY OFF

	CREATE TABLE #Sales(
		[Center] [int] NULL
	,	[net_nb1_sales] [int] NULL
	,	[ContestDollars] [float] NULL
	,	[HairSales] [int] NULL
	,	[SurgerySales] [int] NULL
	,	[Applications] [int] NULL
	)

	DECLARE @Calc TABLE (
		Center int
	,	CenterName varchar(60) NULL
	,   GroupName  varchar(60) NULL
	,   ImageURL  varchar(100) NULL
	,	BudgetDollars  [float] NULL
	,	ContestDollars [float] NULL
	,	ContestHairSales [int] NULL
	,	ContestSurgerySales [int] NULL
	,	ContestApplications [int] NULL
	)

	INSERT INTO #Sales
		SELECT Center
	,	ISNULL(SUM(net_ext),0) + ISNULL(SUM(net_grad),0) + ISNULL(SUM(net_nb1),0) + ISNULL(SUM(sur),0)+ ISNULL(SUM(postEXT),0) 'net_nb1_sales'
	,	ISNULL(SUM(net_nb1$),0) + ISNULL(SUM(net_grad$),0) + ISNULL(SUM(net_ext$),0) + ISNULL(SUM(sur$), 0)+ ISNULL(SUM(postEXT$), 0) 'ContestDollars'
	,	ISNULL(SUM(net_nb1),0) + ISNULL(SUM(net_grad),0) 'HairSales'
	,	SUM(sur) 'SurgerySales'
	,	ISNULL(SUM(net_nb1_apps),0) 'Applications'
	FROM [HCSQL2\SQL2005].INFOSTORE.dbo.hcmvw_sales_summary
	WHERE date BETWEEN  @begdt AND @enddt
	AND Center LIKE '2%'
	GROUP BY  Center

-- NB1 Sales
	SELECT c.ReportingCenterSSID
	,	SUM(ISNULL(FST.NB_GrossNB1Cnt, 0)) AS 'GrossNB1Count'
	,	SUM(ISNULL(FST.NB_TradCnt, 0))
			+ SUM(ISNULL(FST.NB_ExtCnt, 0))
			+ SUM(ISNULL(FST.NB_GradCnt, 0))
			+ SUM(ISNULL(FST.S_SurCnt, 0))
			+ SUM(ISNULL(FST.S_PostExtCnt, 0))
		AS 'NetNB1Count'
	,	SUM(ISNULL(FST.NB_TradAmt, 0))
			+ SUM(ISNULL(FST.NB_ExtAmt, 0))
			+ SUM(ISNULL(FST.NB_GradAmt, 0))
			+ SUM(ISNULL(FST.S_SurAmt, 0))
			+ SUM(ISNULL(FST.S_PostExtAmt, 0))
		AS 'NetNB1Sales'
	INTO #NB1Sales
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FST.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON cm.MembershipSSID = m.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey
	WHERE DD.FullDate BETWEEN @begdt AND @enddt
		AND SC.SalesCodeKey NOT IN (665, 654, 393, 668)
		AND M.RevenueGroupSSID IN (1, 3)
	GROUP BY c.ReportingCenterSSID


-- CONSULTATIONS
	SELECT c.CenterSSID
	,	SUM(ISNULL(FAR.Consultation, 0)) as 'Conultations'
	--,	SUM(ISNULL(FAR.BeBack, 0)) as 'BeBack'
	INTO #Consultations
	FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON FAR.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FAR.ActivityDueDateKey = dd.DateKey
	WHERE DD.FullDate BETWEEN @begdt AND @enddt
	GROUP BY C.CenterSSID

	SELECT
	ccrg.Center
	,ccrg.CenterName
	,	crg.groupdescription GroupName
	,	ccrg.GroupImage as 'ImgURL'
	,	ISNULL(Budget.Budget,0) AS 'BudgetDollars'
	,	ISNULL(ContestDollars, 0) AS 'ContestDollars'
	, ISNULL(n.NetNB1Count, 0) NetNB1Count
	, c.Conultations
	--,dbo.DIVIDE_DECIMAL(ISNULL(n.NetNB1Count,0),ISNULL(c.Conultations,0)) AS ClosePercent -- BI
	,dbo.DIVIDE_DECIMAL(ISNULL(sales.net_nb1_sales,0),ISNULL(c.Conultations,0)) AS ClosePercent -- Infostore
	FROM [HCSQL2\SQL2005].BOSOperations.dbo.vw_ContestCenterGroups ccrg
		INNER JOIN [HCSQL2\SQL2005].BOSOperations.dbo.[ContestReportGroup] crg ON crg.contestid = ccrg.contestid and crg.groupid = ccrg.groupid
		LEFT OUTER JOIN #Sales Sales ON ccrg.center=[Sales].Center
		LEFT JOIN #NB1Sales n ON n.ReportingCenterSSID = ccrg.center
		LEFT JOIN [HCSQL2\SQL2005].BOSOperations.dbo.[Contest_FeastOfSalesBudget] Budget ON ccrg.center=Budget.centerid
		LEFT JOIN #Consultations C ON C.CenterSSID = ccrg.center
	WHERE ccrg.Contestid = 15
GO
