/* CreateDate: 11/22/2013 15:56:07.733 , ModifyDate: 12/05/2013 15:10:00.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_SurgeryClientOverview_Membership
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_SurgeryClientOverview
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_SurgeryClientOverview_Membership '368347'

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_SurgeryClientOverview_Membership]
(
	@ClientIdentifier INT
) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;


	SELECT 'Membership' AS [InformationType]
		,	ClientMembershipBeginDate
		,	ClientMembershipEndDate
		,	M.MembershipDescription
		,	CM.CenterSSID
		,	C.CenterDescriptionNumber
		,	CL.ClientIdentifier
		,	ClientFullName
		,	ClientMembershipStatusDescription
		,	ClientMembershipContractPaidAmount
		,	ClientMembershipMonthlyFee
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient CL
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON CL.ClientKey = CM.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON CM.CenterSSID = C.CenterSSID
	WHERE CL.ClientIdentifier = @ClientIdentifier
		--AND M.BusinessSegmentDescription = 'Surgery'--Commented out because we want to show all memberships not just surgery.
	ORDER BY ClientMembershipBeginDate

END
GO
