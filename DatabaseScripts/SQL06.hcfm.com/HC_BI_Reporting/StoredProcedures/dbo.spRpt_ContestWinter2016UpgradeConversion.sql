/***********************************************************************
PROCEDURE:				spRpt_ContestWinter2016UpgradeConversion
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			ContestSummerUpgradeConversion.rdl
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		01/12/2016
------------------------------------------------------------------------
CHANGE HISTORY:
03/10/2016 - RH - Changed order of Xtrands membership COALESCE statement, Ranking ordered by CM.ClientMembershipEndDate DESC

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ContestWinter2016UpgradeConversion
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestWinter2016UpgradeConversion]

AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @ContestSSID INT

--SET @StartDate = '11/1/2015' --Test dates
--SET @EndDate = '1/31/2016'


SET @StartDate = '1/15/2016' --Real contest dates
SET @EndDate = '3/12/2016'

SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'Winter2016UpgradeConversion')


SET FMTONLY OFF;
SET NOCOUNT OFF;

CREATE TABLE #Conversions(
	CenterSSID INT
     , FullDate DATETIME
     , ClientIdentifier INT
     , Client VARCHAR(150)
     , BioConv INT
     , XtrConv INT
     , EXTConv INT
     , Upgrades INT
     , CurrentMembership VARCHAR(150)
     , PreviousMembership VARCHAR(150)
     , Employee1FullName VARCHAR(150)
     , Employee2FullName VARCHAR(150)
     , Ranking INT
     )

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
,	DC.CenterKey
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
 INSERT INTO #Conversions
 SELECT C.CenterSSID
,	DD.FullDate
,	CLT.ClientIdentifier
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,       ISNULL(FST.NB_BIOConvCnt,0) AS 'BioConv'
,       ISNULL(FST.NB_XTRConvCnt,0) AS 'XtrConv'
,       ISNULL(FST.NB_EXTConvCnt,0) AS 'EXTConv'
,		NULL AS Upgrades
,		M.MembershipDescription AS 'CurrentMembership'
,		PREVM.MembershipDescription AS 'PreviousMembership'
,       E.EmployeeFullName AS 'Employee1FullName'
,       E2.EmployeeFullName AS 'Employee2FullName'
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DD.FullDate DESC) AS 'Ranking'
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
		INNER JOIN #Centers CTR
			ON CM.CenterKey = CTR.CenterKey
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
				)

/**************** Find Upgrades *****************************************************/

 SELECT  C.CenterSSID
,		DD.FullDate
,		CLT.ClientIdentifier
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,       NULL AS 'BioConv'
,       NULL AS 'XtrConv'
,       NULL AS 'EXTConv'
,       ISNULL(FST.PCP_UpgCnt,0) AS 'Upgrades'
,		M.MembershipDescription AS 'CurrentMembership'
,		PREVM.MembershipDescription AS 'PreviousMembership'
,       E.EmployeeFullName AS 'Employee1FullName'
,       E2.EmployeeFullName AS 'Employee2FullName'
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY CM.ClientMembershipEndDate DESC) AS 'Ranking'
INTO #Upgrades
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
            ON COALESCE(CLT.CurrentBioMatrixClientMembershipSSID,CLT.CurrentXtrandsClientMembershipSSID,CLT.CurrentExtremeTherapyClientMembershipSSID,CLT.CurrentSurgeryClientMembershipSSID) = CM.ClientMembershipSSID  --Current membership from Client
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
		INNER JOIN #Centers CTR
			ON CM.CenterKey = CTR.CenterKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	    AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
					/*	'Removal - New Member'
						,	'NEW MEMBER TRANSFER'
						,	'Transfer Member Out'
						,	'Update Membership'	*/
        AND SOD.IsVoidedFlag = 0
		AND ((CASE WHEN DSC.SalesCodeDepartmentSSID IN (1070) THEN 1 ELSE 0 END) <> 0
				OR (CASE WHEN DSC.SalesCodeSSID IN(696,725) THEN 1 ELSE 0 END) <> 0
				OR FST.PCP_UpgCnt <> 0)
		AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Conversions)  --Do not show duplicate clients

/****************  Get Women Membership Updates *****************************************************/

SELECT C.CenterSSID
,       DSO.OrderDate AS 'FullDate'
,		CLT.ClientIdentifier
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,       NULL AS 'BioConv'
,       NULL AS 'XtrConv'
,       NULL AS 'EXTConv'
,		COUNT(CLT.ClientIdentifier) AS 'Updates'
,		DM_To.MembershipDescription AS 'CurrentMembership'
,		DM_From.MembershipDescription AS 'PreviousMembership'
,       ISNULL(REPLACE(PFR.EmployeeFullName, 'Unknown, Unknown', ''), '') AS 'Employee1FullName'
,       ISNULL(REPLACE(STY.EmployeeFullName, 'Unknown, Unknown', ''), '') AS 'Employee2FullName'
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DSO.OrderDate DESC) AS 'Ranking2'
INTO #Updates
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
            ON DD.DateKey = FST.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
            ON DSC.SalesCodeKey = FST.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
            ON DSO.SalesOrderKey = FST.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
            ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_To WITH ( NOLOCK )
                ON DCM_To.ClientMembershipKey = DSO.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_To WITH ( NOLOCK )
                ON DM_To.MembershipKey = DCM_To.MembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM_From WITH ( NOLOCK )
                ON DCM_From.ClientMembershipSSID = DSOD.PreviousClientMembershipSSID
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM_From WITH ( NOLOCK )
                ON DM_From.MembershipKey = DCM_From.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR WITH ( NOLOCK )
                ON CTR.CenterKey = FST.CenterKey
        INNER JOIN #Centers C
            ON C.CenterSSID = CTR.ReportingCenterSSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee PFR WITH ( NOLOCK )
            ON PFR.EmployeeKey = FST.Employee1Key
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY WITH ( NOLOCK )
                ON STY.EmployeeKey = FST.Employee2Key

WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
              AND DSC.SalesCodeDescriptionShort = 'WUPDMBR'
              AND DM_From.MembershipDescription IN ( 'Basic Solutions', 'Bronze Solutions', 'Silver Solutions', 'Gold Solutions' )
              AND DM_To.MembershipDescription IN ( 'Emerald', 'Emerald Plus', 'Sapphire', 'Sapphire Plus' )
              AND DSOD.IsVoidedFlag = 0
			  AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Conversions)  --Do not show duplicate clients
GROUP BY CLT.ClientIdentifier
,		C.CenterSSID
,       DSO.OrderDate
,		CLT.ClientFullName
,		DM_From.MembershipDescription
,       DM_To.MembershipDescription
,       PFR.EmployeeFullName
,       STY.EmployeeFullName


/*********** Insert into #Final *********************************************************************************/

INSERT INTO #Final
SELECT  conv.CenterSSID
,   SUM(ISNULL(conv.BioConv,0)) + SUM(ISNULL(conv.EXTConv,0)) + SUM(ISNULL(conv.XtrConv,0)) AS 'TotalConversions'
,   SUM(ISNULL(conv.BioConv,0)) AS 'BioConv'
,   SUM(ISNULL(conv.XtrConv,0)) AS 'XtrConv'
,   SUM(ISNULL(conv.EXTConv,0)) AS 'EXTConv'
,	NULL AS 'Upgrades'
FROM  #Conversions conv
GROUP BY conv.CenterSSID


INSERT INTO #Final
SELECT u.CenterSSID
,	NULL AS 'TotalConversions'
,	NULL AS 'BioConv'
,	NULL AS 'XtrConv'
,	NULL AS 'EXTConv'
,	SUM(ISNULL(u.Upgrades,0)) AS 'Upgrades'
FROM  #Upgrades u
WHERE u.Ranking = 1
GROUP BY u.CenterSSID

INSERT INTO #Final
SELECT upd.CenterSSID
,	NULL AS 'TotalConversions'
,	NULL AS 'BioConv'
,	NULL AS 'XtrConv'
,	NULL AS 'EXTConv'
,	SUM(ISNULL(upd.Updates,0)) AS 'Upgrades' --Add Updates to the Upgrades
FROM  #Updates upd
WHERE upd.Ranking2 = 1
AND ((upd.PreviousMembership IN ('Basic Solutions', 'Bronze Solutions')
	AND upd.CurrentMembership IN ('Emerald', 'Emerald Plus', 'Sapphire', 'Sapphire Plus'))
		OR (upd.PreviousMembership IN ('Siver Solutions', 'Gold Solutions')
		AND upd.CurrentMembership IN ('Sapphire', 'Sapphire Plus')
		))
GROUP BY upd.CenterSSID



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
	,	CASE WHEN (dbo.DIVIDE_DECIMAL(SUM(ISNULL(S.TotalConversions,0)),C.TargetConversions)>=1
		AND dbo.DIVIDE_DECIMAL(SUM(ISNULL(S.Upgrades,0)),C.TargetUpgrades)>=1) THEN 1 ELSE 0
		END AS 'Qualify'
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
