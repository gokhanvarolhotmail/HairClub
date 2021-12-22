/* CreateDate: 12/09/2013 13:48:18.617 , ModifyDate: 12/09/2013 14:01:31.713 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_CommissionClientOverview_Membership
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			CommissionClientOverview
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		12/09/2013
------------------------------------------------------------------------

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_CommissionClientOverview_Membership '368347'

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_CommissionClientOverview_Membership]
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
	ORDER BY ClientMembershipBeginDate

END
GO
