/***********************************************************************
PROCEDURE:				[spRpt_ContestSummerUpgradeConversion]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HairebrationContest.rdl  --End of Summer
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/15/2015
------------------------------------------------------------------------
NOTES:
07/06/2015 - RH - Changed procedure to find Conversions first and then Upgrades that are not in the Conversion set.
07/13/2015 - RH - Added logic to show only the latest Upgrade - or the latest Conversion (if there hasn't been a more recent Upgrade)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [spRpt_ContestSummerUpgradeConversion]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestSummerUpgradeConversion]

AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @ContestSSID INT


SET @StartDate = '6/16/2015' --Real contest dates
SET @EndDate = '9/7/2015'

SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'SummerUpgradeConversion')


SET FMTONLY OFF;
SET NOCOUNT OFF;

CREATE TABLE #Final(
	CenterSSID	INT
,   TotalConversions	INT
,   BioConv	INT
,   XtrConv	INT
,   EXTConv	INT
,	Upgrades INT)


/********************************** Get List of Centers and Target Data *************************************/

SELECT  CRG.ContestReportGroupSSID
,	CRG.GroupDescription
,	CRG.GroupImage
,	DC.CenterSSID
,	DC.CenterDescriptionNumber
,	DCT.CenterTypeDescriptionShort
,	CCT.TargetSales AS 'Goal'
,	CCT.TargetInitAppsCnt AS 'TargetUpgrades'
,	CCT.TargetConversions AS 'TargetConversions'
,	CCT.BIOConv AS 'TargetBIOConv'
,	CCT.XTRConv AS 'TargetXTRConv'
,	ExtConv AS 'TargetExtConv'
,	CCRG.CenterSortOrder
INTO #Centers
FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON DC.CenterTypeKey = DCT.CenterTypeKey
		INNER JOIN ContestCenterReportGroup CCRG
			ON DC.CenterSSID = CCRG.CenterSSID
				AND CCRG.ContestSSID = @ContestSSID
		INNER JOIN ContestReportGroup CRG
			ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
				AND CRG.ContestSSID = @ContestSSID
		INNER JOIN ContestCenterTarget CCT
			ON DC.CenterSSID = CCT.CenterSSID
				AND CCT.ContestSSID = @ContestSSID
WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
		AND DC.Active = 'Y'


/********************************** Get Conversions *************************************/

 SELECT C.CenterSSID
,	DD.FullDate
,	CLT.ClientIdentifier
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,       ISNULL(FST.NB_BIOConvCnt,0) AS 'BioConv'
,       ISNULL(FST.NB_XTRConvCnt,0) AS 'XtrConv'
,       ISNULL(FST.NB_EXTConvCnt,0) AS 'EXTConv'
,       ISNULL(FST.PCP_UpgCnt,0) AS 'Upgrades'
,		CM.ClientMembershipSSID
,		M.MembershipDescription AS 'CurrentMembership'
,		SOD.PreviousClientMembershipSSID
,		PREVM.MembershipDescription AS 'PreviousMembership'
,       E.EmployeeInitials AS 'Employee1Initials'
,       E2.EmployeeInitials AS 'Employee2Initials'
,       E.EmployeeFullName AS 'Employee1FullName'
,       E2.EmployeeFullName AS 'Employee2FullName'
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DD.FullDate DESC) AS 'Ranking'
INTO #Conversions
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
			ON FST.Employee1Key = E.EmployeeKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
			ON FST.Employee2Key = E2.EmployeeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON (CASE WHEN ISNULL(FST.NB_BIOConvCnt,0) = 1 THEN CLT.CurrentBioMatrixClientMembershipSSID
			 WHEN ISNULL(FST.NB_EXTConvCnt,0) = 1 THEN CLT.CurrentExtremeTherapyClientMembershipSSID
			 WHEN ISNULL(FST.NB_XTRConvCnt,0) = 1 THEN CurrentXtrandsClientMembershipSSID
			ELSE COALESCE(CLT.CurrentBioMatrixClientMembershipSSID,CLT.CurrentXtrandsClientMembershipSSID,CLT.CurrentExtremeTherapyClientMembershipSSID,CLT.CurrentSurgeryClientMembershipSSID)END) = CM.ClientMembershipSSID  --Current membership from Client
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipSSID = M.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
            ON CM.CenterKey = C.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
            ON C.CenterTypeKey = CT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
            ON C.RegionKey = R.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
			ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
			ON PREVCM.MembershipSSID = PREVM.MembershipSSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	    AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
					/*	'Removal - New Member'
						,	'NEW MEMBER TRANSFER'
						,	'Transfer Member Out'
						,	'Update Membership'	*/
        AND SOD.IsVoidedFlag = 0
		AND(ISNULL(FST.NB_BIOConvCnt,0) <> 0
				OR ISNULL(FST.NB_XTRConvCnt,0) <> 0
				OR ISNULL(FST.NB_EXTConvCnt,0) <> 0
				OR (CASE WHEN DSC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) <> 0
				OR (CASE WHEN DSC.SalesCodeSSID IN(696,725) THEN 1 ELSE 0 END) <> 0
				OR FST.PCP_UpgCnt <> 0
				)


--/**************** Find Upgrades *****************************************************/

-- SELECT  C.CenterSSID
--,		DD.FullDate
--,		CLT.ClientIdentifier
--,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
--,       ISNULL(FST.PCP_UpgCnt,0) AS 'Upgrades'
--,		CM.ClientMembershipSSID
--,		M.MembershipDescription AS 'CurrentMembership'
--,		SOD.PreviousClientMembershipSSID
--,		PREVM.MembershipDescription AS 'PreviousMembership'
--,       E.EmployeeInitials AS 'Employee1Initials'
--,       E2.EmployeeInitials AS 'Employee2Initials'
--,       E.EmployeeFullName AS 'Employee1FullName'
--,       E2.EmployeeFullName AS 'Employee2FullName'
--,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DD.FullDate DESC) AS 'Ranking'
--INTO #Upgrades
--FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
--        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--            ON FST.OrderDateKey = dd.DateKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
--            ON FST.SalesCodeKey = DSC.SalesCodeKey
--		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
--			ON FST.ClientKey = CLT.ClientKey
--		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
--			ON FST.Employee1Key = E.EmployeeKey
--		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
--			ON FST.Employee2Key = E2.EmployeeKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
--            ON COALESCE(CLT.CurrentBioMatrixClientMembershipSSID,CLT.CurrentExtremeTherapyClientMembershipSSID,CLT.CurrentXtrandsClientMembershipSSID,CLT.CurrentSurgeryClientMembershipSSID) = CM.ClientMembershipSSID  --Current membership from Client
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
--            ON CM.MembershipSSID = M.MembershipSSID
--        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
--            ON CM.CenterKey = C.CenterKey
--        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
--            ON C.CenterTypeKey = CT.CenterTypeKey
--        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
--            ON C.RegionKey = R.RegionKey
--        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
--            ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
--		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
--			ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
--		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
--			ON PREVCM.MembershipSSID = PREVM.MembershipSSID
--WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
--	    AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
--					/*	'Removal - New Member'
--						,	'NEW MEMBER TRANSFER'
--						,	'Transfer Member Out'
--						,	'Update Membership'	*/
--        AND SOD.IsVoidedFlag = 0
--		AND ((CASE WHEN DSC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) <> 0
--				OR (CASE WHEN DSC.SalesCodeSSID IN(696,725) THEN 1 ELSE 0 END) <> 0
--				OR FST.PCP_UpgCnt <> 0)
--		AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Conversions)  --Do not show duplicate clients

/*********** Insert into #Final *********************************************************************************/

INSERT INTO #Final
SELECT  conv.CenterSSID
,   SUM(ISNULL(conv.BioConv,0)) + SUM(ISNULL(conv.EXTConv,0)) + SUM(ISNULL(conv.XtrConv,0)) AS 'TotalConversions'
,   SUM(ISNULL(conv.BioConv,0)) AS 'BioConv'
,   SUM(ISNULL(conv.XtrConv,0)) AS 'XtrConv'
,   SUM(ISNULL(conv.EXTConv,0)) AS 'EXTConv'
,	SUM(ISNULL(conv.Upgrades,0)) AS 'Upgrades'
FROM  #Conversions conv
WHERE conv.Ranking = 1
GROUP BY conv.CenterSSID



/********************************** Display By Main Group/Center *************************************/
SELECT  C.ContestReportGroupSSID
	,	C.CenterTypeDescriptionShort
	,	C.GroupDescription
	,	C.GroupImage
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.Goal
	,	C.TargetUpgrades
	,	C.TargetConversions
	,	C.TargetBIOConv
	,	C.TargetXTRConv
	,	C.TargetExtConv
	,	SUM(ISNULL(S.TotalConversions,0)) AS 'TotalConversions'
	,	SUM(ISNULL(S.BioConv,0)) AS 'BioConv'
	,	SUM(ISNULL(S.XtrConv,0)) AS 'XtrConv'
	,	SUM(ISNULL(S.EXTConv,0)) AS 'EXTConv'
	,	SUM(ISNULL(S.Upgrades,0)) AS 'Upgrades'
	,	C.CenterSortOrder
FROM    #Centers C
			LEFT OUTER JOIN #Final S
				ON C.CenterSSID = S.CenterSSID
GROUP BY C.ContestReportGroupSSID
	,	C.CenterTypeDescriptionShort
	,	C.GroupDescription
	,	C.GroupImage
	,	C.CenterSSID
	,	C.CenterDescriptionNumber
	,	C.Goal
	,	C.TargetUpgrades
	,	C.TargetConversions
	,	C.TargetBIOConv
	,	C.TargetXTRConv
	,	C.TargetExtConv
	,	C.CenterSortOrder
ORDER BY C.CenterSortOrder



END
