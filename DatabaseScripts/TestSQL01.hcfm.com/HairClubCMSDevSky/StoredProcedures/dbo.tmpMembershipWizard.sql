/* CreateDate: 11/04/2008 11:40:57.650 , ModifyDate: 02/27/2017 09:49:36.203 */
GO
/***********************************************************************

PROCEDURE:				tmpMembershipWizard

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		3/17/09

LAST REVISION DATE: 	3/17/09

--------------------------------------------------------------------------------------------------------
NOTES: 	Returns a list of valid values for the Membership Wizard process.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

tmpMembershipWizard '5D044E24-96C8-4C10-B097-51C16F6F05D4'

***********************************************************************/

CREATE PROCEDURE [dbo].[tmpMembershipWizard]
	@ClientMembershipGUID uniqueidentifier
AS
BEGIN
	SET NOCOUNT ON;

	-- Grab the ClientGUID
	DECLARE @ClientGUID uniqueidentifier
	SELECT @ClientGUID = ClientGUID
	FROM datClientMembership
	WHERE ClientMembershipGUID = @ClientMembershipGUID


	-- Grab a list of all Memberships that can be assigned
	(
	SELECT mrt.MembershipRuleTypeSortOrder,
			mrt.MembershipRuleTypeDescription,
			mr.*,
			mnew.*
	FROM cfgMembershipRule mr
		INNER JOIN cfgMembership mold ON mr.NewMembershipID = mold.MembershipID
		INNER JOIN cfgMembership mnew ON mr.NewMembershipID = mnew.MembershipID
		INNER JOIN lkpMembershipRuleType mrt ON mr.MembershipRuleTypeID = mrt.MembershipRuleTypeID
	WHERE mold.IsDefaultMembershipFlag = 1
		AND NOT mnew.BusinessSegmentID IN (
			SELECT msub.BusinessSegmentID
			FROM datClientMembership cmsub
				INNER JOIN cfgMembership msub ON cmsub.MembershipID = msub.MembershipID
				INNER JOIN lkpClientMembershipStatus cmssub ON cmsub.ClientMembershipStatusID = cmssub.ClientMembershipStatusID
			WHERE cmsub.ClientGUID = @ClientGUID
				AND cmssub.IsActiveMembershipFlag = 1
			)
	)
	UNION
	-- Grab a list of all Memberships that Converted, Renewed, Upgraded, Downgraded, Guaranteed, etc
	(
	SELECT mrt.MembershipRuleTypeSortOrder,
			mrt.MembershipRuleTypeDescription,
			mr.*,
			mnew.*
	FROM cfgMembershipRule mr
		INNER JOIN cfgMembership mold ON mr.NewMembershipID = mold.MembershipID
		INNER JOIN datClientMembership cm ON mold.MembershipID = cm.MembershipID
		INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
		INNER JOIN cfgMembership mnew ON mr.NewMembershipID = mnew.MembershipID
		INNER JOIN lkpMembershipRuleType mrt ON mr.MembershipRuleTypeID = mrt.MembershipRuleTypeID
	WHERE cms.IsActiveMembershipFlag = 1
		AND cm.ClientMembershipGUID = @ClientMembershipGUID
	)
	ORDER BY MembershipRuleTypeSortOrder, MembershipSortOrder

END
GO
