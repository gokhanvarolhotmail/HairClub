/* CreateDate: 06/16/2015 10:52:56.640 , ModifyDate: 07/13/2015 09:59:42.003 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_ContestSummerUpgradeConversionDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HairebrationContest.rdl  --End of Summer
ORIGINAL AUTHOR:		Dominic Leiba
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		06/15/2015
------------------------------------------------------------------------
NOTES:
06/22/2015 - RH - Moved CurrentSurgeryClientMembershipSSID to the end of the COALESCE statement.
06/25/2015 - RH - Changed SalesCodeSSID to 696 from 695; Added AND CM.ClientMembershipStatusDescription IN('Active','Upgraded')
06/25/2015 - RH - Added logic to remove duplicate clients - those who have had an additional upgrade or conversion within the contest dates
07/13/2015 - RH - Added logic to show only the latest Upgrade - or the latest Conversion (if there hasn't been a more recent Upgrade)

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ContestSummerUpgradeConversionDetail 274

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ContestSummerUpgradeConversionDetail](
	@CenterSSID INT)
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
		AND C.CenterSSID = @CenterSSID
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


SELECT CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Upgrades
     , ClientMembershipSSID
     , CurrentMembership
     , PreviousClientMembershipSSID
     , PreviousMembership
     , Employee1Initials
     , Employee2Initials
     , Employee1FullName
     , Employee2FullName
FROM #Conversions
WHERE Ranking = 1
GROUP BY CenterSSID
     , FullDate
     , ClientIdentifier
     , Client
     , BioConv
     , XtrConv
     , EXTConv
     , Upgrades
     , ClientMembershipSSID
     , CurrentMembership
     , PreviousClientMembershipSSID
     , PreviousMembership
     , Employee1Initials
     , Employee2Initials
     , Employee1FullName
     , Employee2FullName



END
GO
