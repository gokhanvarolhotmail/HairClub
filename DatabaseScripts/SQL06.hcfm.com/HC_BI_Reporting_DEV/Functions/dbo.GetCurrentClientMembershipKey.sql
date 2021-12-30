/* CreateDate: 01/03/2014 16:09:15.713 , ModifyDate: 01/09/2018 16:21:36.940 */
GO
/***********************************************************************

FUNCTION: GetCurrentClientMembershipKey

DESTINATION SERVER: SQL06

DESTINATION DATABASE: HC_BI_Reporting

IMPLEMENTOR: Marlon Burrell

--------------------------------------------------------------------------------------------------------
NOTES:

10/21/2013 - MB - Added logic to ignore NonProgram if EXT is valid and to default to BIO if all conditions fail
02/03/2015 - RH - Added logic for Xtrands memberships
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:

SELECT [dbo].[GetCurrentClientMembershipKey] (553860)
***********************************************************************/
CREATE FUNCTION [dbo].[GetCurrentClientMembershipKey] ( @ClientKey INT )
RETURNS INT
AS
BEGIN
    RETURN(
	SELECT 'CurrentClientMembershipKey' =
		CASE
			WHEN ISNULL(CM_BIO.MembershipSSID, -1) NOT IN (-1, 14, 15)
				AND (ISNULL(CM_EXT.MembershipSSID, -1) NOT IN (-1)
					OR ISNULL(CM_SUR.MembershipSSID, -1) NOT IN (-1)
					OR ISNULL(CM_Xtr.MembershipSSID, -1) NOT IN (-1)
			) THEN CM_BIO.ClientMembershipKey
			WHEN ISNULL(CM_EXT.MembershipSSID, -1) NOT IN (-1) THEN CM_EXT.ClientMembershipKey
			WHEN ISNULL(CM_SUR.MembershipSSID, -1) NOT IN (-1) THEN CM_SUR.ClientMembershipKey
			WHEN ISNULL(CM_Xtr.MembershipSSID, -1) NOT IN (-1) THEN CM_Xtr.ClientMembershipKey
			ELSE COALESCE(CM_BIO.ClientMembershipKey, CM_EXT.ClientMembershipKey, CM_SUR.ClientMembershipKey, CM_Xtr.ClientMembershipKey)
		END
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM_BIO
			ON CLT.CurrentBioMatrixClientMembershipSSID = CM_BIO.ClientMembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M_BIO
			ON CM_BIO.MembershipKey = M_BIO.MembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM_EXT
			ON CLT.CurrentExtremeTherapyClientMembershipSSID = CM_EXT.ClientMembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M_EXT
			ON CM_EXT.MembershipKey = M_EXT.MembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM_SUR
			ON CLT.CurrentSurgeryClientMembershipSSID = CM_SUR.ClientMembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M_SUR
			ON CM_SUR.MembershipKey = M_SUR.MembershipKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM_Xtr
			ON CLT.CurrentXtrandsClientMembershipSSID = CM_Xtr.ClientMembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M_Xtr
			ON CM_Xtr.MembershipKey = M_Xtr.MembershipKey
	WHERE CLT.ClientKey = @ClientKey
)
END
GO
