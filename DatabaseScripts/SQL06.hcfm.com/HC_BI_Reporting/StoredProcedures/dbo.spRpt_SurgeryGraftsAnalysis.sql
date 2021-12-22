/* CreateDate: 07/12/2011 16:55:15.527 , ModifyDate: 09/11/2012 15:09:46.330 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				[spRpt_SurgeryGraftsAnalysis]

VERSION:				v2.0

DESTINATION SERVER:		HCSQL2

DESTINATION DATABASE: 	SQL05.HairClubCMS

RELATED APPLICATION:  	Surgery Grafts Analysis Report

AUTHOR: 				James Hannah

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED: 		4/13/2009

LAST REVISION DATE: 	07/12/2011

------------------------------------------------------------------------------------------------------
NOTES: 	Returns statistics related to surgery sales and number of grafts
	07/21/2009 -- DL -- Excluded Surgery Closeout transactions from results being returned.
	08/05/2009 -- JH -- Instead of using 'PPSG' from accumulator we are actually doing division just in case data
						entry get srewed up and accumulator does pick up all transactions.  ex:  ticket #45528
	10/07/2009 -- JH -- Added Extra Grafts to Report as per Ticket Request 47157.
	09/10/2010 -- MB --	Added Grafts Lost and Contracted Grafts columns to report.  WO# 55235
	09/13/2010 -- MB --	Adjusted Contracted Grafts column  WO# 55235
	03/16/2011 -- MB -- Added IsSurgeryReversalFlag=0 to applicable queries
	07/11/2011 -- KM -- Migrated Stored Proc to SQL06
	09/11/2012 -- MB -- Rewrote procedure to use new BI tables (DR request)
------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spRpt_SurgeryGraftsAnalysis] '6/1/12', '9/10/12'
------------------------------------------------------------------------------------------------------
GRANT EXECUTE ON [spRpt_SurgeryGraftsAnalysis] TO IIS
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_SurgeryGraftsAnalysis] (
	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT CM.ClientMembershipKey
	,	DDR.DoctorRegionDescription AS 'Doctor'
	,	CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')' AS 'Client'
	,	C.CenterDescriptionNumber AS 'Center'
	,	MAX(DD.FullDate) AS 'SurgeryDate'
	,	CASE WHEN MAX(FST.S_SurgeryPerformedCnt)=0 THEN 0 ELSE MAX(ISNULL(GraftsAdjustment.QuantityTotalChange, 0)) END AS 'EstimatedGrafts'
	,	MAX(CASE WHEN ISNULL(GraftsAdjustment.QuantityTotalAdjustment, 0)>0
			THEN ISNULL(GraftsAdjustment.QuantityTotalAdjustment, 0) ELSE 0 END)
		AS 'ExtraGrafts'
	,	MAX(CASE WHEN SC.SalesCodeDepartmentSSID=5060 AND AA.QuantityUsedAdjustment > ISNULL(GraftsAdjustment.QuantityTotalChange, 0)
			THEN AA.QuantityUsedAdjustment - ISNULL(GraftsAdjustment.QuantityTotalChange, 0) ELSE 0 END)
			-
			MAX(CASE WHEN ISNULL(GraftsAdjustment.QuantityTotalAdjustment, 0)>0
				THEN ISNULL(GraftsAdjustment.QuantityTotalAdjustment, 0) ELSE 0 END)
		AS 'ExtraGraftsFree'
	,	MAX(FST.S_SurgeryGraftsCnt) AS 'ActualGrafts'
	,	MAX(FST.S_SurgeryPerformedAmt) AS 'TotalRevenueCollected'
	,	MAX(FST.S_SurgeryPerformedCnt) AS 'ProcedureCount'
	,	ISNULL(SUM(CASE WHEN SC.SalesCodeDepartmentSSID=2025 AND FST.Quantity>0 THEN PostEXT.PostEXTPMTCount ELSE PostEXT.PostEXTREFCount END), 0) AS 'PostEXTCount'
	,	ISNULL(SUM(CASE WHEN SC.SalesCodeDepartmentSSID=2025 AND FST.Quantity>0 THEN PostEXT.PostEXTPMT ELSE PostEXT.PostEXTREF END), 0) AS 'PostEXTPaid'
	,	MIN(CASE WHEN SC.SalesCodeDepartmentSSID=1040 AND ISNULL(GraftsAdjustment.QuantityTotalAdjustment, 0)<0
			THEN ISNULL(GraftsAdjustment.QuantityTotalAdjustment, 0) ELSE 0 END)
		AS 'Lost'
	,	dbo.DIVIDE_DECIMAL(SUM(FST.S_SurgeryPerformedAmt), SUM(FST.S_SurgeryGraftsCnt)) AS 'AveragePerGraft'
	,	MAX(FST.S_SurgeryGraftsCnt) AS 'AverageCaseSize'
	,	CASE WHEN MAX(FST.S_SurgeryPerformedCnt)=0 THEN 0 ELSE MAX(ISNULL(GraftsAdjustment.QuantityTotalChange, 0)) END AS 'TotalContractedGrafts'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON CM.CenterKey = c.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimDoctorRegion DDR
			ON C.DoctorRegionKey = DDR.DoctorRegionKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON CM.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON SOD.SalesCodeSSID = SC.SalesCodeSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAccumulatorAdjustment AA
			ON FST.ClientMembershipKey = AA.ClientMembershipKey
			AND AA.AccumulatorSSID=12
			AND AA.QuantityUsedAdjustment<>0
		LEFT OUTER JOIN (
			SELECT ClientMembershipKey
			,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1010, 1075, 1090, 1030) THEN AA.QuantityTotalChange ELSE 0 END) AS 'QuantityTotalChange'
			,	SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (1040) THEN AA.QuantityTotalAdjustment ELSE 0 END) AS 'QuantityTotalAdjustment'
			FROM HC_BI_CMS_DDS.bi_cms_dds.DimAccumulatorAdjustment AA
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON AA.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON SOD.SalesCodeSSID = SC.SalesCodeSSID
			WHERE AA.AccumulatorSSID IN (1, 12)
				AND SC.SalesCodeDepartmentSSID IN (1010, 1075, 1090, 1030, 1040)
			GROUP BY ClientMembershipKey
		) GraftsAdjustment
			ON FST.ClientMembershipKey = GraftsAdjustment.ClientMembershipKey
		LEFT OUTER JOIN (
			SELECT FST.ClientMembershipKey
			,	ISNULL(SUM(FST.S_PostExtCnt), 0) AS 'PostEXTPMTCount'
			,	ISNULL(SUM(FST.S_PostExtAmt), 0) AS 'PostEXTPMT'
			,	ISNULL(SUM(CASE WHEN FST.Quantity < 0 THEN FST.S_PostExtAmt END), 0) AS 'PostEXTREF'
			,	ISNULL(SUM(CASE WHEN FST.Quantity < 0 THEN FST.S_PostExtCnt END), 0) AS 'PostEXTREFCount'
			FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON FST.SalesCodeKey = SC.SalesCodeKey
			WHERE SC.SalesCodeDepartmentSSID IN (2025)
			GROUP BY FST.ClientMembershipKey
		) PostEXT
			ON FST.ClientMembershipKey = PostEXT.ClientMembershipKey
	WHERE DD.FullDate BETWEEN @StartDate and @EndDate
		AND (FST.S_SurgeryPerformedCnt<>0
			OR PostEXT.PostEXTPMTCount<>0
			OR PostEXT.PostEXTREFCount<>0)
		AND SC.SalesCodeDepartmentSSID IN (1040, 2025, 5060)
		AND C.CenterSSID LIKE '[356]%'
	GROUP BY CM.ClientMembershipKey
	,	DDR.DoctorRegionDescription
	,	CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')'
	,	C.CenterDescriptionNumber
	ORDER BY DDR.DoctorRegionDescription
	,	C.CenterDescriptionNumber
	,	CLT.ClientFullName + ' (' + CONVERT(VARCHAR, CLT.ClientIdentifier) + ')'
END
GO
