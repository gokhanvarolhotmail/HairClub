/* CreateDate: 04/10/2014 12:16:05.663 , ModifyDate: 04/10/2014 12:16:05.663 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthMembershipsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthMembershipsExport
***********************************************************************/
CREATE PROCEDURE spSvc_BarthMembershipsExport
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Membership Data *************************************/
SELECT  DM.MembershipKey
,       DM.MembershipSSID
,       DM.MembershipDescription
,       DM.MembershipDescriptionShort
,       DM.BusinessSegmentKey
,       DM.BusinessSegmentSSID
,       DM.BusinessSegmentDescription
,       DM.BusinessSegmentDescriptionShort
,       DM.RevenueGroupSSID
,       DM.RevenueGroupDescription
,       DM.RevenueGroupDescriptionShort
,       DM.GenderSSID
,       DM.GenderDescription
,       DM.GenderDescriptionShort
,       DM.MembershipDurationMonths
,       DM.MembershipContractPrice
,       DM.MembershipMonthlyFee
,       DM.MembershipSortOrder
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
ORDER BY DM.MembershipSortOrder

END
GO
