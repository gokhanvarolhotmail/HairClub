/* CreateDate: 08/01/2013 17:02:57.200 , ModifyDate: 08/02/2013 11:03:56.350 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[spSVC_ClientHistoryFrom2008Sales]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_BI_Reporting]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Client history from 2008 sales
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spSVC_ClientHistoryFrom2008Sales]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spSVC_ClientHistoryFrom2008Sales] AS
BEGIN
	SET NOCOUNT ON


/*
		Get all NB (Traditional, Gradual, EXT, Surgery) sales from 2008
	*/
	SELECT c.ReportingCenterSSID AS 'CenterSSID'
	,	dd.FullDate AS 'SaleDate'
	,	clt.ClientIdentifier
	,	clt.GenderSSID
	,	clt.ClientDateOfBirth
	,	DATEDIFF(YEAR, clt.ClientDateOfBirth, dd.FullDate) AS 'AgeAtSale'
	,	m.MembershipSSID
	,	m.MembershipDescription
	,	m.BusinessSegmentDescriptionShort AS 'BusinessSegment'
	INTO #NBSales2008
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON fst.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
			ON fst.CenterKey = c.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON fst.ClientKey = clt.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
			ON fst.MembershipKey = m.MembershipKey
	WHERE dd.FullDate BETWEEN '1/1/08' AND '12/31/08'
		AND c.CenterSSID LIKE '[23]%'
		AND (fst.NB_ExtCnt = 1
			OR fst.NB_GradCnt = 1
			OR fst.NB_TradCnt = 1
			OR fst.S1_NetSalesCnt = 1
			OR fst.SA_NetSalesCnt = 1)


	/*
		Get all desired metrics (NB Revenue, PCP Revenue, NB Apps, NB Conversions for initial
		population from 2008 through 2012
	*/
	SELECT clt.ClientIdentifier
	--NB Revenue
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2008 THEN
			( ISNULL(fst.NB_ExtAmt, 0)
			+ ISNULL(fst.NB_GradAmt, 0)
			+ ISNULL(fst.NB_TradAmt, 0)
			+ ISNULL(fst.S_SurAmt, 0))
		ELSE 0 END) AS 'NBRevenue_2008'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2009 THEN
			( ISNULL(fst.NB_ExtAmt, 0)
			+ ISNULL(fst.NB_GradAmt, 0)
			+ ISNULL(fst.NB_TradAmt, 0)
			+ ISNULL(fst.S_SurAmt, 0))
		ELSE 0 END) AS 'NBRevenue_2009'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2010 THEN
			( ISNULL(fst.NB_ExtAmt, 0)
			+ ISNULL(fst.NB_GradAmt, 0)
			+ ISNULL(fst.NB_TradAmt, 0)
			+ ISNULL(fst.S_SurAmt, 0))
		ELSE 0 END) AS 'NBRevenue_2010'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2011 THEN
			( ISNULL(fst.NB_ExtAmt, 0)
			+ ISNULL(fst.NB_GradAmt, 0)
			+ ISNULL(fst.NB_TradAmt, 0)
			+ ISNULL(fst.S_SurAmt, 0))
		ELSE 0 END) AS 'NBRevenue_2011'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2012 THEN
			( ISNULL(fst.NB_ExtAmt, 0)
			+ ISNULL(fst.NB_GradAmt, 0)
			+ ISNULL(fst.NB_TradAmt, 0)
			+ ISNULL(fst.S_SurAmt, 0))
		ELSE 0 END) AS 'NBRevenue_2012'

	--PCP Revenue
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2008 AND nb.BusinessSegment<>'EXT' THEN ISNULL(fst.PCP_PCPAmt, 0) ELSE 0 END) AS 'PCPRevenue_2008'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2009 AND nb.BusinessSegment<>'EXT' THEN ISNULL(fst.PCP_PCPAmt, 0) ELSE 0 END) AS 'PCPRevenue_2009'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2010 AND nb.BusinessSegment<>'EXT' THEN ISNULL(fst.PCP_PCPAmt, 0) ELSE 0 END) AS 'PCPRevenue_2010'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2011 AND nb.BusinessSegment<>'EXT' THEN ISNULL(fst.PCP_PCPAmt, 0) ELSE 0 END) AS 'PCPRevenue_2011'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2012 AND nb.BusinessSegment<>'EXT' THEN ISNULL(fst.PCP_PCPAmt, 0) ELSE 0 END) AS 'PCPRevenue_2012'

	--EXTMEM Revenue
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2008 AND nb.BusinessSegment='EXT' THEN ISNULL(fst.PCP_ExtMemAmt, 0) ELSE 0 END) AS 'EXTMEMRevenue_2008'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2009 AND nb.BusinessSegment='EXT' THEN ISNULL(fst.PCP_ExtMemAmt, 0) ELSE 0 END) AS 'EXTMEMRevenue_2009'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2010 AND nb.BusinessSegment='EXT' THEN ISNULL(fst.PCP_ExtMemAmt, 0) ELSE 0 END) AS 'EXTMEMRevenue_2010'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2011 AND nb.BusinessSegment='EXT' THEN ISNULL(fst.PCP_ExtMemAmt, 0) ELSE 0 END) AS 'EXTMEMRevenue_2011'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2012 AND nb.BusinessSegment='EXT' THEN ISNULL(fst.PCP_ExtMemAmt, 0) ELSE 0 END) AS 'EXTMEMRevenue_2012'

	--NB Apps
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2008 THEN ISNULL(fst.NB_AppsCnt, 0)	ELSE 0 END) AS 'NBApps_2008'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2009 THEN ISNULL(fst.NB_AppsCnt, 0) ELSE 0 END) AS 'NBApps_2009'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2010 THEN ISNULL(fst.NB_AppsCnt, 0)	ELSE 0 END) AS 'NBApps_2010'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2011 THEN ISNULL(fst.NB_AppsCnt, 0)	ELSE 0 END) AS 'NBApps_2011'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2012 THEN ISNULL(fst.NB_AppsCnt, 0)	ELSE 0 END) AS 'NBApps_2012'

	--BIO Conversions
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2008 THEN ISNULL(fst.NB_BIOConvCnt, 0) ELSE 0 END) AS 'NBConversions_2008'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2009 THEN ISNULL(fst.NB_BIOConvCnt, 0) ELSE 0 END) AS 'NBConversions_2009'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2010 THEN ISNULL(fst.NB_BIOConvCnt, 0) ELSE 0 END) AS 'NBConversions_2010'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2011 THEN ISNULL(fst.NB_BIOConvCnt, 0) ELSE 0 END) AS 'NBConversions_2011'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2012 THEN ISNULL(fst.NB_BIOConvCnt, 0) ELSE 0 END) AS 'NBConversions_2012'

	--EXT Conversions
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2008 THEN ISNULL(fst.NB_EXTConvCnt, 0) ELSE 0 END) AS 'EXTConversions_2008'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2009 THEN ISNULL(fst.NB_EXTConvCnt, 0) ELSE 0 END) AS 'EXTConversions_2009'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2010 THEN ISNULL(fst.NB_EXTConvCnt, 0) ELSE 0 END) AS 'EXTConversions_2010'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2011 THEN ISNULL(fst.NB_EXTConvCnt, 0) ELSE 0 END) AS 'EXTConversions_2011'
	,	SUM(CASE WHEN YEAR(dd.FullDate)=2012 THEN ISNULL(fst.NB_EXTConvCnt, 0) ELSE 0 END) AS 'EXTConversions_2012'
	INTO #Metrics
	FROM #NBSales2008 nb
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
			ON nb.ClientIdentifier = clt.ClientIdentifier
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction fst
			ON clt.ClientKey = fst.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
			ON fst.OrderDateKey = dd.DateKey
	WHERE dd.FullDate BETWEEN '1/1/08' AND '12/31/12'
		AND (fst.NB_AppsCnt <> 0
			OR fst.NB_BIOConvCnt <> 0
			OR fst.NB_EXTConvCnt <> 0
			OR fst.NB_ExtAmt <> 0
			OR fst.NB_GradAmt <> 0
			OR fst.NB_TradAmt <> 0
			OR fst.S_SurAmt <> 0
			OR fst.PCP_PCPAmt <> 0
			OR fst.PCP_ExtMemAmt <> 0
		)
	GROUP BY clt.ClientIdentifier


	--SELECT nb.ClientIdentifier
	--,	COUNT(nb.ClientIdentifier) AS 'MonthsActive'
	--INTO #PCP
	--FROM #NBSales2008 nb
	--	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
	--		ON nb.ClientIdentifier = clt.ClientIdentifier
	--	INNER JOIN HC_Accounting.dbo.FactPCPDetail pcp
	--		ON clt.ClientKey = pcp.ClientKey
	--	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
	--		ON pcp.DateKey = dd.DateKey
	--WHERE dd.fullDate BETWEEN '1/1/09' AND '12/31/09'
	--	AND pcp.PCP - pcp.EXT = 1
	--GROUP BY nb.ClientIdentifier


	/*
		Consolidate data
	*/
	SELECT nb.CenterSSID
	,	nb.SaleDate
	,	nb.ClientIdentifier
	,	CASE WHEN ISNULL(nb.GenderSSID, 1)=1 THEN 'M' ELSE 'F' END AS 'Gender'
	,	nb.ClientDateOfBirth
	,	nb.AgeAtSale
	,	CASE
			WHEN nb.AgeAtSale BETWEEN 0 AND 19 THEN 'Below 20'
			WHEN nb.AgeAtSale BETWEEN 20 AND 29 THEN '20 to 29'
			WHEN nb.AgeAtSale BETWEEN 30 AND 39 THEN '30 to 39'
			WHEN nb.AgeAtSale BETWEEN 40 AND 49 THEN '40 to 49'
			WHEN nb.AgeAtSale BETWEEN 50 AND 59 THEN '50 to 59'
			WHEN nb.AgeAtSale BETWEEN 60 AND 69 THEN '60 to 69'
			WHEN nb.AgeAtSale > 70 THEN '70 and above'
			ELSE 'Don''t Know'
		END AS 'AgeRange'
	,	nb.MembershipSSID
	,	nb.MembershipDescription
	,	nb.BusinessSegment
	,	ISNULL(m.NBRevenue_2008, 0) AS 'NBRevenue_2008'
	,	ISNULL(m.NBRevenue_2009, 0) AS 'NBRevenue_2009'
	,	ISNULL(m.NBRevenue_2010, 0) AS 'NBRevenue_2010'
	,	ISNULL(m.NBRevenue_2011, 0) AS 'NBRevenue_2011'
	,	ISNULL(m.NBRevenue_2012, 0) AS 'NBRevenue_2012'
	,	ISNULL(m.PCPRevenue_2008, 0) AS 'PCPRevenue_2008'
	,	ISNULL(m.PCPRevenue_2009, 0) AS 'PCPRevenue_2009'
	,	ISNULL(m.PCPRevenue_2010, 0) AS 'PCPRevenue_2010'
	,	ISNULL(m.PCPRevenue_2011, 0) AS 'PCPRevenue_2011'
	,	ISNULL(m.PCPRevenue_2012, 0) AS 'PCPRevenue_2012'
	,	ISNULL(m.EXTMEMRevenue_2008, 0) AS 'EXTMEMRevenue_2008'
	,	ISNULL(m.EXTMEMRevenue_2009, 0) AS 'EXTMEMRevenue_2009'
	,	ISNULL(m.EXTMEMRevenue_2010, 0) AS 'EXTMEMRevenue_2010'
	,	ISNULL(m.EXTMEMRevenue_2011, 0) AS 'EXTMEMRevenue_2011'
	,	ISNULL(m.EXTMEMRevenue_2012, 0) AS 'EXTMEMRevenue_2012'
	,	ISNULL(m.NBApps_2008, 0) AS 'NBApps_2008'
	,	ISNULL(m.NBApps_2009, 0) AS 'NBApps_2009'
	,	ISNULL(m.NBApps_2010, 0) AS 'NBApps_2010'
	,	ISNULL(m.NBApps_2011, 0) AS 'NBApps_2011'
	,	ISNULL(m.NBApps_2012, 0) AS 'NBApps_2012'
	,	ISNULL(m.NBConversions_2008, 0) AS 'NBConversions_2008'
	,	ISNULL(m.NBConversions_2009, 0) AS 'NBConversions_2009'
	,	ISNULL(m.NBConversions_2010, 0) AS 'NBConversions_2010'
	,	ISNULL(m.NBConversions_2011, 0) AS 'NBConversions_2011'
	,	ISNULL(m.NBConversions_2012, 0) AS 'NBConversions_2012'
	,	ISNULL(m.EXTConversions_2008, 0) AS 'EXTConversions_2008'
	,	ISNULL(m.EXTConversions_2009, 0) AS 'EXTConversions_2009'
	,	ISNULL(m.EXTConversions_2010, 0) AS 'EXTConversions_2010'
	,	ISNULL(m.EXTConversions_2011, 0) AS 'EXTConversions_2011'
	,	ISNULL(m.EXTConversions_2012, 0) AS 'EXTConversions_2012'
	--,	CASE WHEN p.MonthsActive>=1 THEN 1 ELSE 0 END AS 'Active2009'
	FROM #NBSales2008 nb
		LEFT OUTER JOIN #Metrics m
			ON nb.ClientIdentifier = m.ClientIdentifier
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient c
			ON nb.ClientIdentifier = c.ClientIdentifier
		--LEFT OUTER JOIN #PCP p
		--	ON nb.ClientIdentifier = p.ClientIdentifier
	ORDER BY nb.CenterSSID
	,	nb.SaleDate
	,	nb.ClientIdentifier

END
GO
