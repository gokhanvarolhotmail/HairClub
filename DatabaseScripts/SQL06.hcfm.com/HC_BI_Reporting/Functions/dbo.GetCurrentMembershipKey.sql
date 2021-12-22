/***********************************************************************

FUNCTION: GetCurrentMembershipKey

DESTINATION SERVER: SQL06

DESTINATION DATABASE: HC_BI_Reporting

IMPLEMENTOR: Marlon Burrell

--------------------------------------------------------------------------------------------------------
NOTES:

10/21/2013 - MB - Added logic to ignore NonProgram if EXT is valid and to default to BIO if all conditions fail
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:

SELECT [dbo].[GetCurrentMembershipKey] (553860)
***********************************************************************/
CREATE FUNCTION [dbo].[GetCurrentMembershipKey] ( @ClientKey INT)
RETURNS INT AS
BEGIN
RETURN(
	SELECT 'CurrentMembershipKey' =
		CASE
			WHEN ISNULL(CM_BIO.MembershipSSID, -1) NOT IN (-1, 14, 15)
				AND (ISNULL(CM_EXT.MembershipSSID, -1) NOT IN (-1)
					OR ISNULL(CM_SUR.MembershipSSID, -1) NOT IN (-1)
			) THEN M_BIO.MembershipKey
			WHEN ISNULL(CM_EXT.MembershipSSID, -1) NOT IN (-1) THEN M_EXT.MembershipKey
			WHEN ISNULL(CM_SUR.MembershipSSID, -1) NOT IN (-1) THEN M_SUR.MembershipKey
			ELSE COALESCE(M_BIO.MembershipKey, M_EXT.MembershipKey, M_SUR.MembershipKey)
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
	WHERE CLT.ClientKey = @ClientKey
)
END
