/* CreateDate: 06/11/2012 15:57:30.867 , ModifyDate: 01/20/2016 12:38:07.377 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[hcmvw_sales_summary] AS

SELECT
center, [date], conultations, beback, gross_nb1, net_nb1, net_nb1$, net_nb1_apps, net_nb1_conv, net_ext_conv,net_xtr_conv
, open_pcp
, close_pcp
, pcp$, nb2$
, receivables
, clients_serviced, service$, retail$, net_ext, net_ext$, net_grad, net_grad$, gross_sur, sur, sur$, postEXT, postEXT$, leads

FROM (
SELECT Center
	,	CenterKey
	,	[Date]
	,	DateKey
	--,	SUM(conultations) AS 'conultations'
	--,	SUM(beback) AS 'beback'
	,	SUM(gross_nb1) AS 'gross_nb1'
	,	SUM(net_nb1) AS 'net_nb1'
	,	SUM(net_nb1$) AS 'net_nb1$'
	,	SUM(net_nb1_apps) AS 'net_nb1_apps'
	,	SUM(net_nb1_conv) AS 'net_nb1_conv'
	,	SUM(net_ext_conv) AS 'net_ext_conv'
	,	SUM(net_xtr_conv) AS 'net_xtr_conv' --Added RH 11/20/2014
	,	SUM(open_pcp) AS 'open_pcp'
	,	SUM(close_pcp) AS 'close_pcp'
	,	SUM(pcp$) AS 'pcp$'
	,	SUM(nb2$) AS 'nb2$'
	,	SUM(receivables) AS 'receivables'
	,	SUM(clients_serviced) AS 'clients_serviced'
	,	SUM(service$) AS 'service$'
	,	SUM(retail$) AS 'retail$'
	,	SUM(net_ext) AS 'net_ext'
	,	SUM(net_ext$) AS 'net_ext$'
	,	SUM(net_grad) AS 'net_grad'
	,	SUM(net_grad$) AS 'net_grad$'
	,	SUM(gross_sur) AS 'gross_sur'
	,	SUM(sur) AS 'sur'
	,	SUM(sur$) AS 'sur$'
	,	SUM(postEXT) AS 'postEXT'
	,	SUM(postEXT$) AS 'postEXT$'
	--,	SUM(leads) AS 'leads'
	FROM (
		SELECT
		Center.CenterSSID		AS 'center'
		,	Sales.CenterKey
		,	d.FullDate			AS 'date'
		,   d.DateKey
		--,	SUM(ISNULL(FAR.Consultation, 0)) AS 'conultations'--conultations
		--,	1	AS 'beback'--beback
		,	[NB_GrossNB1Cnt]	AS 'gross_nb1'
		,	[NB_TradCnt]		AS 'net_nb1'
		,	[NB_TradAmt]		AS 'net_nb1$'
		,	[NB_AppsCnt]		AS 'net_nb1_apps'
		,	[NB_BIOConvCnt]		AS 'net_nb1_conv'
		,	[NB_EXTConvCnt]		AS 'net_ext_conv'
		,	[NB_XTRConvCnt]		AS 'net_xtr_conv' --Added RH 11/20/2014
		,	0	AS 'open_pcp'--NOT USED
		,	0	AS 'close_pcp'--NOT USED
		,	[PCP_PCPAmt]		AS 'pcp$'
		,	[PCP_NB2Amt]		AS 'nb2$'
		,	0	AS 'receivables'--TO BE UPDATED
		,	[ClientServicedCnt]	AS 'clients_serviced'
		,	[ServiceAmt]		AS 'service$'
		,	[RetailAmt]			AS 'retail$'
		,	[NB_ExtCnt]			AS 'net_ext'
		,	[NB_ExtAmt]			AS 'net_ext$'
		,	[NB_GradCnt]		AS 'net_grad'
		,	[NB_GradAmt]		AS 'net_grad$'
		,	[S_GrossSurCnt]		AS 'gross_sur'
		,	[S_SurCnt]			AS 'sur'
		,	[S_SurAmt]			AS 'sur$'
		,	[S_PostExtCnt]		AS 'postEXT'
		,	[S_PostExtAmt]		AS 'postEXT$'
		--,	COUNT(1)			AS 'leads'
	FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactSalesTransaction] Sales
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter Center ON Center.CenterKey = Sales.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate d ON d.DateKey = Sales.OrderDateKey
	) AS SalesSummary
	GROUP BY [Center], CenterKey, date, DateKey
	) T

	/* Get Daily Consultations Data */
	--INNER JOIN (
	--	SELECT Center.CenterKey, dFA.FullDate
	--	FROM  HC_BI_ENT_DDS.bi_ent_dds.FactAccounting FA
	--	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dFA ON dFA.DateKey = FA.DateKey
	--	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter Center ON Center.CenterSSID = FA.CenterID
	--  WHERE FA.[AccountID] IN ( 10410 )
	--) FA ON FA.CenterKey = t.CenterKey AND YEAR(FA.FullDate) = YEAR(t.[Date]) AND MONTH(FA.FullDate) = MONTH(t.[Date])

	/* Get Daily Consultations Data */
	INNER JOIN (
	  SELECT FAR.CenterKey, FAR.ActivityDueDateKey
	  , SUM(ISNULL(FAR.Consultation, 0)) AS 'conultations'
	  , SUM(ISNULL(FAR.BeBack, 0)) AS 'BeBack'
      FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
      GROUP BY FAR.CenterKey, FAR.ActivityDueDateKey
	) FAR ON FAR.CenterKey = T.CenterKey AND FAR.ActivityDueDateKey = T.DateKey

	/* Get Daily Actual Leads Data */
	INNER JOIN (
      SELECT FL.CenterKey, FL.LeadCreationDateKey, COUNT(1) AS 'Leads'
      FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
      GROUP BY FL.CenterKey, FL.LeadCreationDateKey
	) FL ON FL.CenterKey = T.CenterKey AND FL.LeadCreationDateKey = T.DateKey
--WHERE [DATE] BETWEEN '2012-05-01' AND '2012-05-31'
--order by center, [date]
GO
