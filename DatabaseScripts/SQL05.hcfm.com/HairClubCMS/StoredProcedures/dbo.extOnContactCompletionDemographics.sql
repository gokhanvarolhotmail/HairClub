/* CreateDate: 12/11/2012 14:57:18.580 , ModifyDate: 12/11/2012 14:57:18.580 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCompletionDemographics

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Interface with OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CompletionDemographics

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCompletionDemographics
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCompletionDemographics]
(
	@ActivityID varchar(50),
	@Gender varchar(50),
	@Birthday varchar(50),
	@OccupationCode int,
	@EthnicityCode int,
	@MaritalStatusCode int,
	@Norwood varchar(50),
	@Ludwig varchar(50),
	@Age int,
	@CompletionType varchar(50),
	@CompletedBy varchar(50),
	@Performer varchar(50),
	@PriceQuoted MONEY,
	@SolutionOffered varchar(100),
	@NoSaleReason varchar(200)
)
AS
BEGIN TRANSACTION


DECLARE @ActivityDemographicID varchar(25)

EXEC extOnContactCreatePrimaryKey 10, 'cstd_activity_demographic', 'activity_demographic_id', @ActivityDemographicID OUTPUT, 'ONC'


IF EXISTS ( SELECT activity_id FROM HCMSkylineTest..cstd_activity_demographic WHERE activity_id = @ActivityID )
  BEGIN
    DELETE FROM HCMSkylineTest..cstd_activity_demographic
    WHERE activity_id = @ActivityID

	IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END

IF @CompletionType = 'NOSHOW'
  BEGIN
    INSERT  intO HCMSkylineTest..cstd_activity_demographic (activity_demographic_id, activity_id, gender, birthday, occupation_code, ethnicity_code, maritalstatus_code, norwood, ludwig, age, creation_date, created_by_user_code, updated_date, updated_by_user_code, performer, price_quoted, solution_offered, no_sale_reason)
		VALUES (@ActivityDemographicID, @ActivityID, '?', '2003-01-01', '0', '0', '0', 'Unknown', 'Unknown', 0, GETDATE(), @CompletedBy, GETDATE(), @CompletedBy, @Performer, @PriceQuoted, @SolutionOffered, @NoSaleReason)

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END
ELSE
  BEGIN
    INSERT  intO HCMSkylineTest..cstd_activity_demographic (activity_demographic_id, activity_id, gender, birthday, occupation_code, ethnicity_code, maritalstatus_code, norwood, ludwig, age, creation_date, created_by_user_code, updated_date, updated_by_user_code, performer, price_quoted, solution_offered, no_sale_reason)
		VALUES (@ActivityDemographicID, @ActivityID, @Gender, @Birthday, @OccupationCode, @EthnicityCode, @MaritalStatusCode, @Norwood, @Ludwig, @Age, GETDATE(), @CompletedBy, GETDATE(), @CompletedBy, @Performer, @PriceQuoted, @SolutionOffered, @NoSaleReason)

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END

COMMIT TRANSACTION
GO
