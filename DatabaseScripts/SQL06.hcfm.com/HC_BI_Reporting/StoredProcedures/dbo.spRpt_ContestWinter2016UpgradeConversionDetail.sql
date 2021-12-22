/* CreateDate: 01/12/2016 16:35:12.873 , ModifyDate: 03/11/2016 17:23:43.770 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ContestWinter2016UpgradeConversionDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			ContestSummerUpgradeConversionDetail
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/15/2015
------------------------------------------------------------------------
NOTES:
IF @MainGroupID > 200 --Then one center
IF @MainGroupID = 100 --Then all centers
IF @MainGroupID BETWEEN 40 AND 50 -- Then a contest group has been selected

IF @ConvUpg = 1 --Then 'Conversions'
IF @ConvUpg = 2 --Then 'Upgrades'
------------------------------------------------------------------------
CHANGE HISTORY:
03/10/2016 - RH - Changed order of Xtrands membership COALESCE statement, Ranking ordered by CM.ClientMembershipEndDate DESC
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ContestWinter2016UpgradeConversionDetail 201, 1
EXEC spRpt_ContestWinter2016UpgradeConversionDetail 255, 2

EXEC spRpt_ContestWinter2016UpgradeConversionDetail 100, 1
EXEC spRpt_ContestWinter2016UpgradeConversionDetail 100, 2

EXEC spRpt_ContestWinter2016UpgradeConversionDetail 44, 1
EXEC spRpt_ContestWinter2016UpgradeConversionDetail 47, 2


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestWinter2016UpgradeConversionDetail](
	@MainGroupID INT
	,	@ConvUpg INT)
AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
DECLARE @ContestSSID INT



SET @StartDate = '1/15/2016' --Real contest dates
SET @EndDate = '3/12/2016'

SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'Winter2016UpgradeConversion')


SET FMTONLY OFF;
SET NOCOUNT OFF;


/**********************************Find Centers *****************************************/
CREATE TABLE #Centers (
CenterSSID INT
,	CenterKey INT
)

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


IF @MainGroupID > 200 --Then one center
BEGIN
INSERT INTO #Centers
SELECT CenterSSID, CenterKey FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterSSID = @MainGroupID
END
ELSE
IF @MainGroupID = 100 --Then all centers
BEGIN
INSERT INTO #Centers
SELECT CenterSSID, CenterKey FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter WHERE CenterSSID LIKE '[2]%' AND Active = 'Y'
END
ELSE
IF @MainGroupID BETWEEN 40 AND 50 -- Then a contest group has been selected
BEGIN
INSERT INTO #Centers
SELECT CCRG.CenterSSID, CTR.CenterKey
FROM ContestCenterReportGroup CCRG
INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
	ON CTR.CenterSSID = CCRG.CenterSSID
WHERE ContestSSID = @ContestSSID AND ContestReportGroupSSID = @MainGroupID
END


/********************************** Get Conversions *************************************/

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
INTO #Conv
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = dd.DateKey
		INNER JOIN #Centers CTR
			ON FST.CenterKey = CTR.CenterKey
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
		AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Conv)  --Do not show duplicate clients


/****************  Get Women Membership Updates *****************************************************/

SELECT  C.CenterSSID
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
,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DSO.OrderDate DESC) AS 'Rank'
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
			  AND CLT.ClientIdentifier NOT IN(SELECT ClientIdentifier FROM #Conv)  --Do not show duplicate clients
GROUP BY CLT.ClientIdentifier
,		C.CenterSSID
,       DSO.OrderDate
,		CLT.ClientFullName
,		DM_From.MembershipDescription
,       DM_To.MembershipDescription
,       PFR.EmployeeFullName
,       STY.EmployeeFullName

/******************************* INSERT records into #Conversions ************************************************/

INSERT INTO #Conversions
SELECT CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Upgrades
     , CurrentMembership
     , PreviousMembership
     , Employee1FullName
     , Employee2FullName
     , Ranking
FROM #Conv
WHERE Ranking = 1

INSERT INTO #Conversions
SELECT CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Upgrades
     , CurrentMembership
     , PreviousMembership
     , Employee1FullName
     , Employee2FullName
     , Ranking
FROM #Upgrades u
WHERE Ranking = 1


INSERT INTO #Conversions
SELECT CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Updates AS 'Upgrades'
     , CurrentMembership
     , PreviousMembership
     , Employee1FullName
     , Employee2FullName
     , [Rank]
FROM #Updates u
WHERE [Rank] = 1
AND ((u.PreviousMembership IN ('Basic Solutions', 'Bronze Solutions')
	AND u.CurrentMembership IN ('Emerald', 'Emerald Plus', 'Sapphire', 'Sapphire Plus'))
		OR (u.PreviousMembership IN ('Siver Solutions', 'Gold Solutions')
		AND u.CurrentMembership IN ('Sapphire', 'Sapphire Plus')
		))



SELECT C.CenterSSID
     , C.FullDate
     , C.ClientIdentifier
     , C.Client
     , C.BioConv
     , C.XtrConv
     , C.EXTConv
     , SUM(C.Upgrades) AS 'Upgrades'
     , C.CurrentMembership
     , C.PreviousMembership
     , C.Employee1FullName
     , C.Employee2FullName
	 , o_EFt.LastFeeDate
	 , o_EFt.LastFeeAmount
INTO #Final
FROM #Conversions C
	OUTER APPLY (
		SELECT  TOP 1
				CLT.ClientIdentifier
		,		cfb.RunDate AS 'LastFeeDate'
		,       pct.ChargeAmount AS 'LastFeeAmount'
		FROM    SQL05.HairClubCMS.dbo.datPayCycleTransaction pct
				INNER JOIN SQL05.HairClubCMS.dbo.lkpPayCycleTransactionType t
					ON t.PayCycleTransactionTypeID = pct.PayCycleTransactionTypeID
				INNER JOIN SQL05.HairClubCMS.dbo.datCenterFeeBatch cfb
					ON cfb.CenterFeeBatchGUID = pct.CenterFeeBatchGUID
				INNER JOIN SQL05.HairClubCMS.dbo.datClient CLT
					ON CLT.ClientGUID = pct.ClientGUID
		WHERE   pct.IsSuccessfulFlag = 1
				AND clt.ClientIdentifier = C.ClientIdentifier
		ORDER BY cfb.RunDate DESC
	) o_EFt
WHERE C.Ranking = 1
GROUP BY C.CenterSSID
     , C.FullDate
     , C.ClientIdentifier
     , C.Client
     , C.BioConv
     , C.XtrConv
     , C.EXTConv
     , C.CurrentMembership
     , C.PreviousMembership
     , C.Employee1FullName
     , C.Employee2FullName
	 , o_EFt.LastFeeDate
	 , o_EFt.LastFeeAmount

/*************** Pull according to Conversions or Upgrades *********************************/

IF @ConvUpg = 1 --Conversions
BEGIN
SELECT CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Upgrades
     , CurrentMembership
     , PreviousMembership
     , Employee1FullName
     , Employee2FullName
     , LastFeeDate
     , LastFeeAmount
FROM #Final
WHERE (BioConv <> 0
     OR XtrConv <> 0
     OR EXTConv <> 0)
END
ELSE  --@ConvUpg = 2  --Upgrades
BEGIN
SELECT CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Upgrades
     , CurrentMembership
     , PreviousMembership
     , Employee1FullName
     , Employee2FullName
     , LastFeeDate
     , LastFeeAmount
FROM #Final
WHERE Upgrades <> 0
END

END
GO
