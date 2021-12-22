/* CreateDate: 09/23/2019 12:25:13.150 , ModifyDate: 06/15/2021 11:55:19.657 */
GO
/*
==============================================================================
PROCEDURE:				selSalesConsultationSalesTypes

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Jeremy Miller

IMPLEMENTOR: 			Jeremy Miller

DATE IMPLEMENTED: 		08/29/2019

LAST REVISION DATE: 	08/29/2019

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 08/29/2019    JLM Created. Copied from extOnContactGetSalesTypeList
		* 05/20/2020    AO Updated.  #14468  Add isMemberShip field
		* 15/06/2021    AA New org changes
==============================================================================
SAMPLE EXECUTION:
EXEC selSalesConsultationSalesTypes 211
==============================================================================
*/

CREATE PROCEDURE [dbo].[selSalesConsultationSalesTypes]
	@CenterID int
AS
BEGIN
	SET NOCOUNT ON

    DECLARE @RetailMembershipDescriptionShort NVARCHAR(10) = 'RETAIL'
    DECLARE @AssignMembershipRuleDescriptionShort NVARCHAR(10) = 'Assign'

	DECLARE @SurgeryCenterNumber int = 0
	DECLARE @IsLiveWithBosley bit = 0

	SELECT TOP(1) @IsLiveWithBosley = IsLiveWithBosley FROM cfgConfigurationCenter WHERE CenterID = @CenterID

	IF @CenterID > 200 AND @CenterID < 300
		SET @SurgeryCenterNumber = @CenterID + 100
	ELSE IF @CenterID > 700
		SET @SurgeryCenterNumber = @CenterID - 200

	SELECT
		mem.BOSSalesTypeCode
		, mem.[MembershipDescription]
		, mem.[MembershipID]
		, bs.[BusinessSegmentDescriptionShort]
		, bs.[BusinessSegmentDescription]
		, rg.[RevenueGroupDescriptionShort]
		, cmem.ContractPriceMale
		, cmem.ContractPriceFemale
		, confm.IsBosleyMembership
	FROM cfgMembership mem
		INNER JOIN cfgConfigurationCenter cent ON cent.CenterID = @CenterID
		INNER JOIN lkpCenterBusinessType cbt ON cbt.CenterBusinessTypeID = cent.CenterBusinessTypeID
		INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = mem.BusinessSegmentID
		INNER JOIN lkpRevenueGroup rg ON rg.RevenueGroupID = mem.RevenueGroupID
		INNER JOIN cfgCenterMembership cmem ON cmem.MembershipID = mem.MembershipID
		INNER JOIN cfgConfigurationMembership confm ON cmem.MembershipID = confm.MembershipID
		OUTER APPLY
		(
			SELECT TOP(1) mr.MembershipRuleID
			FROM cfgMembershipRule mr
				INNER JOIN lkpMembershipRuleType rt ON rt.MembershipRuleTypeID = mr.MembershipRuleTypeID
				INNER JOIN cfgMembership currmem on mr.CurrentMembershipID = currmem.MembershipID
			WHERE mr.IsActiveFlag = 1
				AND currmem.MembershipDescriptionShort = @RetailMembershipDescriptionShort
				AND mr.NewMembershipID = mem.MembershipID
				AND rt.MembershipRuleTypeDescriptionShort = @AssignMembershipRuleDescriptionShort
				AND mr.CenterBusinessTypeID = cent.CenterBusinessTypeID

		) mrule
		OUTER APPLY
		(
			SELECT TOP(1) re.CenterMembershipRuleExclusionID
			FROM cfgCenterMembershipRuleExclusion re
				INNER JOIN lkpMembershipRuleType rt on re.MembershipRuleTypeID = rt.MembershipRuleTypeID
				INNER JOIN cfgCenterMembership cm on re.CenterMembershipID = cm.CenterMembershipID
				INNER JOIN cfgMembership currmem on cm.MembershipID = currmem.MembershipID
			WHERE re.NewMembershipID = mem.MembershipID
				AND re.IsActiveFlag = 1
				AND cm.CenterID = @CenterID
				AND currmem.MembershipDescriptionShort = @RetailMembershipDescriptionShort
				AND rt.MembershipRuleTypeDescriptionShort = @AssignMembershipRuleDescriptionShort

		) mruleexclusion
	WHERE BOSSalesTypeCode IS NOT NULL AND BOSSalesTypeCode <> 0
		AND cmem.IsActiveFlag = 1
		AND mrule.MembershipRuleID IS NOT NULL
		AND mruleexclusion.CenterMembershipRuleExclusionID IS NULL
		AND (
				(@IsLiveWithBosley = 1 AND cmem.CenterID = @CenterID)
				OR (@IsLiveWithBosley = 0 AND cmem.CenterID IN (@CenterID, @SurgeryCenterNumber))
		)
		--Exclude Retail Membership from results
		AND mem.MembershipDescriptionShort <> @RetailMembershipDescriptionShort
	ORDER BY mem.[MembershipDescription]
END
GO
