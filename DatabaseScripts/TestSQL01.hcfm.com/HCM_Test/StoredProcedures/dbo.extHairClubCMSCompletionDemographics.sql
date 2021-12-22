/* CreateDate: 01/23/2017 15:44:16.030 , ModifyDate: 01/23/2017 15:44:16.030 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSCompletionDemographics
DESTINATION SERVER:		SQL03
DESTINATION DATABASE:	HCM
AUTHOR:					Mike Tovbin
IMPLEMENTOR:			Mike Tovbin
DATE IMPLEMENTED:		01/18/2017
------------------------------------------------------------------------
NOTES:

	01/18/2017 - MT - Created (TFS #8454)
------------------------------------------------------------------------
SAMPLE EXECUTION:

DECLARE @ContactID nvarchar(25)
EXEC extHairClubCMSCompletionDemographics @ContactID, 201, 'Mike', 'Test', 'M', NULL, 920, 3625701, NULL, NULL, NULL, NULL, '123 Main', NULL, 'Green Bay', 'WI', '54323', 'US', 'BOSPExtRef', 0, 'ENGLISH',
				'UNKNOWN', 'CLIENT'
***********************************************************************/
CREATE PROCEDURE [dbo].[extHairClubCMSCompletionDemographics]
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
	@CompletedBy nchar(20),
	@Performer varchar(50),
	@PriceQuoted MONEY,
	@SolutionOffered varchar(100),
	@NoSaleReason varchar(200),
	@DISCStyle varchar(1)
)
AS

	IF EXISTS (SELECT * FROM oncd_activity WHERE activity_id = @ActivityID AND result_code IS NOT NULL AND result_code <> '')
		RAISERROR ('Consultation has already been completed.', -- Message text.
               16, -- Severity.
               1 -- State.
               );


	IF EXISTS ( SELECT activity_id FROM cstd_activity_demographic WHERE activity_id = @ActivityID )
	  BEGIN
		UPDATE cstd_activity_demographic SET
			gender = ISNULL(@Gender,'?')
			, birthday = @Birthday
			, occupation_code = @OccupationCode
			, ethnicity_code = @EthnicityCode
			, maritalstatus_code = @MaritalStatusCode
			, norwood = @Norwood
			, ludwig = @Ludwig
			, age = @Age
			, updated_date = GETDATE()
			, updated_by_user_code = @CompletedBy
			, performer = @Performer
			, price_quoted = @PriceQuoted
			, solution_offered = @SolutionOffered
			, no_sale_reason = @NoSaleReason
			, disc_style = @DISCStyle
		WHERE activity_id = @ActivityID

		IF @@ERROR <> 0
		  BEGIN
			ROLLBACK TRANSACTION
			RETURN @@ERROR
		  END
	  END
	ELSE
	  BEGIN

		DECLARE @ActivityDemographicID varchar(25)
	    EXEC extHairClubCMSCreatePrimaryKey 10, 'cstd_activity_demographic', 'activity_demographic_id', @ActivityDemographicID OUTPUT, 'ONC'

		INSERT INTO cstd_activity_demographic (
				activity_demographic_id, activity_id, gender, birthday,	occupation_code, ethnicity_code, maritalstatus_code, norwood, ludwig, age, creation_date,
				created_by_user_code, updated_date, updated_by_user_code, performer, price_quoted, solution_offered, no_sale_reason, disc_style)
			VALUES (@ActivityDemographicID, @ActivityID, ISNULL(@Gender,'?'), @Birthday, @OccupationCode, @EthnicityCode, @MaritalStatusCode, ISNULL(@Norwood,'Unknown'), ISNULL(@Ludwig,'Unknown'),
			@Age, GETDATE(), @CompletedBy, GETDATE(), @CompletedBy, ISNULL(@Performer,''), ISNULL(@PriceQuoted,0.00), ISNULL(@SolutionOffered,''), ISNULL(@NoSaleReason,''), ISNULL(@DISCStyle,'x'))

	  END
GO
