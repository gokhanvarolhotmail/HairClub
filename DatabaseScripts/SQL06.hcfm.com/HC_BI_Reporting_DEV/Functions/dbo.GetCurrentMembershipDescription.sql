/* CreateDate: 10/11/2013 14:29:25.987 , ModifyDate: 02/03/2015 17:20:37.650 */
GO
/***********************************************************************

FUNCTION: GetCurrentMembershipDescription

DESTINATION SERVER: SQL06

DESTINATION DATABASE: HC_BI_Reporting

IMPLEMENTOR: Marlon Burrell

--------------------------------------------------------------------------------------------------------
NOTES:

10/21/2013 - MB - Added logic to ignore NonProgram if EXT is valid and to default to BIO if all conditions fail
02/03/2015 - RH - Added logic for Xtrands memberships
--------------------------------------------------------------------------------------------------------

SAMPLE EXEC:

SELECT [dbo].[GetCurrentMembershipDescription] (553860)
***********************************************************************/
CREATE FUNCTION [dbo].[GetCurrentMembershipDescription] ( @ClientKey INT )
RETURNS VARCHAR(50)
AS
BEGIN
    RETURN(
	SELECT 'CurrentMembershipDescription' =
		CASE
			WHEN ISNULL(CM_BIO.MembershipSSID, -1) NOT IN (-1, 14, 15)
				AND (ISNULL(CM_EXT.MembershipSSID, -1) NOT IN (-1)
					OR ISNULL(CM_SUR.MembershipSSID, -1) NOT IN (-1)
					OR ISNULL(CM_Xtr.MembershipSSID, -1) NOT IN (-1)
			) THEN M_BIO.MembershipDescription
			WHEN ISNULL(CM_EXT.MembershipSSID, -1) NOT IN (-1) THEN M_EXT.MembershipDescription
			WHEN ISNULL(CM_SUR.MembershipSSID, -1) NOT IN (-1) THEN M_SUR.MembershipDescription
			WHEN ISNULL(CM_Xtr.MembershipSSID, -1) NOT IN (-1) THEN M_Xtr.MembershipDescription
			ELSE COALESCE(M_BIO.MembershipDescription, M_EXT.MembershipDescription, M_SUR.MembershipDescription, M_Xtr.MembershipDescription)
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
			ON CLT.CurrentSurgeryClientMembershipSSID = CM_Xtr.ClientMembershipSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M_Xtr
			ON CM_Xtr.MembershipKey = M_Xtr.MembershipKey
	WHERE CLT.ClientKey = @ClientKey
)
END
GO
