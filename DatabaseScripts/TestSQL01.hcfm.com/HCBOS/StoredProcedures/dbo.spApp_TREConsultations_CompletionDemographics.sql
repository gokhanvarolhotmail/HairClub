/* CreateDate: 09/22/2008 15:03:18.047 , ModifyDate: 05/24/2012 13:53:07.487 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CompletionDemographics
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/17/2008
-- Date Implemented:		7/17/2008
-- Date Last Modified:		7/17/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	BOS
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CompletionDemographics
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CompletionDemographics]
(
	@ActivityDemographicID VARCHAR(50),
	@ActivityID VARCHAR(50),
	@Gender VARCHAR(50),
	@Birthday VARCHAR(50),
	@OccupationCode INT,
	@EthnicityCode INT,
	@MaritalStatusCode INT,
	@Norwood VARCHAR(50),
	@Ludwig VARCHAR(50),
	@Age INT,
	@CompletionType VARCHAR(50),
	@CompletedBy VARCHAR(50),
	@Performer VARCHAR(50),
	@PriceQuoted MONEY,
	@SolutionOffered VARCHAR(100),
	@NoSaleReason VARCHAR(200),
	@DiSCStyle VARCHAR(1)
)
AS
BEGIN TRANSACTION

IF EXISTS ( SELECT  [activity_id]
            FROM    [HCMSkylineTest].[dbo].[cstd_activity_demographic]
            WHERE   [activity_id] = @ActivityID )
  BEGIN
    DELETE  FROM [HCMSkylineTest].[dbo].[cstd_activity_demographic]
    WHERE   [activity_id] = @ActivityID

	IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END

IF @CompletionType = 'NOSHOW'
  BEGIN
    INSERT  INTO [HCMSkylineTest].[dbo].[cstd_activity_demographic]
            (
             [activity_demographic_id]
            ,[activity_id]
            ,[gender]
            ,[birthday]
            ,[occupation_code]
            ,[ethnicity_code]
            ,[maritalstatus_code]
            ,[norwood]
            ,[ludwig]
            ,[age]
            ,[creation_date]
            ,[created_by_user_code]
            ,[updated_date]
            ,[updated_by_user_code]
			,[performer]
			,[price_quoted]
			,[solution_offered]
			,[no_sale_reason]
			,[DiSC_Style]
		)
    VALUES  (
             @ActivityDemographicID
            ,@ActivityID
            ,'?'
            ,'2003-01-01'
            ,'0'
            ,'0'
            ,'0'
            ,'Unknown'
            ,'Unknown'
            ,0
            ,GETDATE()
            ,@CompletedBy
            ,GETDATE()
            ,@CompletedBy
			,@Performer
			,@PriceQuoted
			,@SolutionOffered
			,@NoSaleReason
			,@DiSCStyle)

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END
ELSE
  BEGIN
    INSERT  INTO [HCMSkylineTest].[dbo].[cstd_activity_demographic]
            (
             [activity_demographic_id]
            ,[activity_id]
            ,[gender]
            ,[birthday]
            ,[occupation_code]
            ,[ethnicity_code]
            ,[maritalstatus_code]
            ,[norwood]
            ,[ludwig]
            ,[age]
            ,[creation_date]
            ,[created_by_user_code]
            ,[updated_date]
            ,[updated_by_user_code]
			,[performer]
			,[price_quoted]
			,[solution_offered]
			,[no_sale_reason]
			,[DiSC_Style]
	      )
    VALUES  (
             @ActivityDemographicID
            ,@ActivityID
            ,@Gender
            ,@Birthday
            ,@OccupationCode
            ,@EthnicityCode
            ,@MaritalStatusCode
            ,@Norwood
            ,@Ludwig
            ,@Age
            ,GETDATE()
            ,@CompletedBy
            ,GETDATE()
            ,@CompletedBy
			,@Performer
			,@PriceQuoted
			,@SolutionOffered
			,@NoSaleReason
			,@DiSCStyle)

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END

COMMIT TRANSACTION
GO
