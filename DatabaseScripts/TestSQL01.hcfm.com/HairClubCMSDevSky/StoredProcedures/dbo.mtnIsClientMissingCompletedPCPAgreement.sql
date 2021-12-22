/* CreateDate: 03/23/2020 07:35:37.043 , ModifyDate: 03/23/2020 07:35:37.043 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				mtnIsClientMissingCompletedPCPAgreement

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Sue Lemery

IMPLEMENTOR: 			Sue Lemery

DATE IMPLEMENTED: 		01/24/2020

LAST REVISION DATE: 	01/24/2020

--------------------------------------------------------------------------------------------------------
NOTES:  For a client, all active PCP level memberships in the Xtrands+, EXT, and Xtrands business segments
		are checked for an agreement in ‘Complete’ status, within the past three years, and for the same
		membership as the active PCP level membership.  If this is true then true is return, otherwise
		false is returned.

		* 01/24/2020	SAL	Created (TFS #13764)
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

mtnIsClientMissingCompletedPCPAgreement '3D5BC35B-F7AE-4AAA-84DD-C4F2AB82F4D5'

***********************************************************************/

CREATE PROCEDURE [dbo].[mtnIsClientMissingCompletedPCPAgreement]
	@ClientGUID uniqueidentifier
AS
BEGIN
  SET NOCOUNT ON

  BEGIN TRY

		--Get the list of active PCP memberships for the client
		--Get the distinct list of PCP memberships that have an agreement uploaded in the past three years
		--If any of the memberships from the first list are not in the second list, then return true for mtnIsClientMissingCompletedPCPAgreement

		DECLARE @RecurringBusinessRevenueGroup NVARCHAR(10) = 'PCP'
		DECLARE @ClientAgreementDocumentType NVARCHAR(10) = 'Agreement'
		DECLARE @CompleteAgreementDocumentType NVARCHAR(10) = 'COMPLETE'
		DECLARE @IsClientMissingCompletedPCPAgreement BIT = 0

		SELECT ActiveMemberships.* INTO #ActiveRecurringLevelMemberships
		FROM (	--Xtrands+
				SELECT m.MembershipID
				FROM datClient c
					inner join datClientMembership cm on c.CurrentBioMatrixClientMembershipGUID = cm.ClientMembershipGUID
					inner join cfgMembership m on cm.MembershipID = m.MembershipID
					inner join lkpRevenueGroup rg on m.RevenueGroupID = rg.RevenueGroupID and rg.RevenueGroupDescriptionShort = @RecurringBusinessRevenueGroup
					inner join lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID and cms.IsActiveMembershipFlag = 1
				WHERE c.ClientGUID = @ClientGUID

				UNION

				--EXT
				SELECT m.MembershipID
				FROM datClient c
					inner join datClientMembership cm on c.CurrentExtremeTherapyClientMembershipGUID = cm.ClientMembershipGUID
					inner join cfgMembership m on cm.MembershipID = m.MembershipID
					inner join lkpRevenueGroup rg on m.RevenueGroupID = rg.RevenueGroupID and rg.RevenueGroupDescriptionShort = @RecurringBusinessRevenueGroup
					inner join lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID and cms.IsActiveMembershipFlag = 1
				WHERE c.ClientGUID = @ClientGUID

				UNION

				--Xtrands
				SELECT m.MembershipID
				FROM datClient c
					inner join datClientMembership cm on c.CurrentXtrandsClientMembershipGUID = cm.ClientMembershipGUID
					inner join cfgMembership m on cm.MembershipID = m.MembershipID
					inner join lkpRevenueGroup rg on m.RevenueGroupID = rg.RevenueGroupID and rg.RevenueGroupDescriptionShort = @RecurringBusinessRevenueGroup
					inner join lkpClientMembershipStatus cms on cm.ClientMembershipStatusID = cms.ClientMembershipStatusID and cms.IsActiveMembershipFlag = 1
				WHERE c.ClientGUID = @ClientGUID
			) ActiveMemberships

		IF EXISTS (	SELECT *
					FROM #ActiveRecurringLevelMemberships
					WHERE MembershipID not in (	SELECT DISTINCT mem.MembershipID
												FROM datClientMembershipDocument cmd
													INNER JOIN datClientMembership cm ON cmd.ClientMembershipGUID = cm.ClientMembershipGUID
													INNER JOIN cfgMembership mem ON cm.MembershipID = mem.MembershipID
													INNER JOIN lkpRevenueGroup rg ON mem.RevenueGroupID = rg.RevenueGroupID
													INNER JOIN lkpDocumentType dt ON cmd.DocumentTypeID = dt.DocumentTypeID
													INNER JOIN lkpDocumentStatus ds ON cmd.DocumentStatusID = ds.DocumentStatusID
												WHERE cmd.ClientGUID = @ClientGUID
													AND rg.RevenueGroupDescriptionShort = @RecurringBusinessRevenueGroup
													AND dt.DocumentTypeDescriptionShort = @ClientAgreementDocumentType
													AND ds.DocumentStatusDescriptionShort = @CompleteAgreementDocumentType
													AND cmd.CreateDate > DATEADD(YEAR, -3, GETUTCDATE())
												))

		BEGIN
			SET @IsClientMissingCompletedPCPAgreement = 1
		END

		SELECT @IsClientMissingCompletedPCPAgreement AS IsClientMissingCompletedPCPAgreement

  END TRY
  BEGIN CATCH

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;

    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
  END CATCH
END
GO
