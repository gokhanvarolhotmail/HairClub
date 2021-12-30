/* CreateDate: 09/25/2009 17:19:09.657 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CreateBeBackActivity
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Marlon Burrell
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			9/17/2009
-- Date Implemented:		9/17/2009
-- Date Last Modified:		9/17/2009
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	HCM
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- Execution Scenarios:
--
-- REFUND			--> along with the ContactID, CenterID (Non-Surgery) and @Performer, pass @ResultCode as 'SHOWNOSALE'
--					--> in order to update the surgery consultation flag on the contact record
-- MEMBERSHIP		--> along with the ContactID, CenterID (Non-Surgery) and @Performer, pass @ResultCode as 'SHOWSALE'.
--					--> the contact record will not be updated in this scenario
--
-- 09/28/2009 -	DL	--> Changed the order in which records are saved to:
--					--> ONCD_ACTIVITY
--					--> ONCD_ACTIVITY_USER
--					--> CSTD_ACTIVITY_DEMOGRAPHIC
--					--> ONCD_ACTIVITY_CONTACT
--					--> CSTD_CONTACT_COMPLETION
--					--> ONCD_CONTACT
--
-- 09/28/2009 - DL	--> Corrected the spelling on the surgery_consultation_flag column
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CreateBeBackActivity '2DUXPCEITC', '281', 'dleiba', 'SHOWSALE'
EXEC spApp_TREConsultations_CreateBeBackActivity '2DUXPCEITC', '281', 'dleiba', 'SHOWNOSALE'
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CreateBeBackActivity]
(
	@ContactID VARCHAR(10),
	@CenterID VARCHAR(20),
	@Performer VARCHAR(50),
	@ResultCode VARCHAR(50)
)
AS
BEGIN TRANSACTION

IF EXISTS ( SELECT  [contact_id]
            FROM    [HCM].[dbo].[oncd_contact]
            WHERE   [contact_id] = @ContactID
                    AND [surgery_consultation_flag] = 'Y' )
  BEGIN
	-- ONCD_ACTIVITY.
    DECLARE @ActivityID VARCHAR(10)

	EXEC [HCM].[dbo].[onc_create_primary_key] @key_length = 10, @table_name = 'oncd_activity', @column_name = 'activity_id', @primary_key = @ActivityID OUTPUT,
	  @suffix = 'ITC'

    INSERT  INTO [HCM].[dbo].[oncd_activity]
            (
              [activity_id]
            , [due_date]
            , [start_time]
            , [action_code]
            , [result_code]
            , [completed_by_user_code]
            , [completion_date]
            , [completion_time]
            , [created_by_user_code]
            , [creation_date]
            , [updated_by_user_code]
            , [updated_date]
            , [description]
            , [cst_activity_type_code]
            , [source_code]
            )
    VALUES  (
              @ActivityID
            , CAST(CONVERT(VARCHAR(11), GETDATE(), 101) AS DATETIME)
            , ( GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT), 0, 1) AS DATETIME) )
            , 'BEBACK'
            , @ResultCode
            , @CenterID
            , CAST(CONVERT(VARCHAR(11), GETDATE(), 101) AS DATETIME)
            , ( GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT), 0, 1) AS DATETIME) )
            , @CenterID
            , GETDATE()
            , @CenterID
            , GETDATE()
            , 'BEBACK'
            , 'INBOUND'
            , NULL )

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END


	-- ONCD_ACTIVITY_USER.
    DECLARE @ActivityUserID VARCHAR(10)

    EXEC [HCM].[dbo].[onc_create_primary_key] @key_length = 10, @table_name = 'oncd_activity_user', @column_name = 'activity_user_id',
      @primary_key = @ActivityUserID OUTPUT, @suffix = 'ITC'

    INSERT  INTO [HCM].[dbo].[oncd_activity_user]
            (
              [activity_user_id]
            , [activity_id]
            , [user_code]
            , [primary_flag]
            , [sort_order]
            , [created_by_user_code]
            , [creation_date]
            , [updated_by_user_code]
            , [updated_date]
            )
    VALUES  (
              @ActivityUserID
            , @ActivityID
            , @CenterID
            , 'Y'
            , 0
            , @CenterID
            , GETDATE()
            , @CenterID
            , GETDATE() )

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END


	-- CSTD_ACTIVITY_DEMOGRAPHIC.
    DECLARE @ActivityDemographicID VARCHAR(10)

    EXEC [HCM].[dbo].[onc_create_primary_key] @key_length = 10, @table_name = 'cstd_activity_demographic', @column_name = 'activity_demographic_id',
      @primary_key = @ActivityDemographicID OUTPUT, @suffix = 'ITC'

    DECLARE @LastActivityID VARCHAR(10)

	SELECT  TOP 1 @LastActivityID = [oncd_activity_contact].[activity_id]
	FROM    [HCM].[dbo].[oncd_activity]
			INNER JOIN [HCM].[dbo].[oncd_activity_contact]
			  ON [oncd_activity].[activity_id] = [oncd_activity_contact].[activity_id]
				 AND [oncd_activity_contact].[primary_flag] = 'Y'
			INNER JOIN [HCM].[dbo].[oncd_contact]
			  ON [oncd_activity_contact].[contact_id] = [oncd_contact].[contact_id]
	WHERE   [oncd_contact].[contact_id] = @ContactID
			AND [oncd_activity].[result_code] IN ( 'SHOWNOSALE', 'SHOWSALE' )
	ORDER BY [oncd_activity_contact].[creation_date] DESC

	DECLARE @Gender CHAR(1)
    DECLARE @Birthday DATETIME
    DECLARE @OccupationCode VARCHAR(10)
    DECLARE @EthnicityCode VARCHAR(50)
    DECLARE @MaritalStatusCode VARCHAR(10)
    DECLARE @Norwood VARCHAR(50)
    DECLARE @Ludwig VARCHAR(50)
    DECLARE @Age INT
    DECLARE @PriceQuoted MONEY
    DECLARE @SolutionOffered VARCHAR(100)
    DECLARE @NoSaleReason VARCHAR(200)

	IF ISNULL(@LastActivityID, '') <> ''
	  BEGIN
		SELECT  @Gender = ISNULL([gender], '?')
		,       @Birthday = ISNULL([birthday], CAST(CONVERT(VARCHAR(11), GETDATE(), 101) AS DATETIME))
		,       @OccupationCode = ISNULL([occupation_code], '0')
		,       @EthnicityCode = ISNULL([ethnicity_code], '0')
		,       @MaritalStatusCode = ISNULL([maritalstatus_code], '0')
		,       @Norwood = ISNULL([norwood], 'Unknown')
		,       @Ludwig = ISNULL([ludwig], 'Unknown')
		,       @Age = ISNULL([age], 0)
		,       @PriceQuoted = ISNULL([price_quoted], 0)
		,       @SolutionOffered = ISNULL([solution_offered], '')
		,       @NoSaleReason = ISNULL([no_sale_reason], '')
		FROM    [HCM].[dbo].[cstd_activity_demographic]
		WHERE   [activity_id] = @LastActivityID
	  END
	ELSE
	  BEGIN
		SET @Gender = '?'
		SET @Birthday = GETDATE()
		SET @OccupationCode = '0'
		SET @EthnicityCode = '0'
		SET @MaritalStatusCode = '0'
		SET @Norwood = 'Unknown'
		SET @Ludwig = 'Unknown'
		SET @Age = 0
		SET @PriceQuoted = 0
		SET @SolutionOffered = ''
		SET @NoSaleReason = ''
	  END

    INSERT  INTO [HCM].[dbo].[cstd_activity_demographic]
            (
              [activity_demographic_id]
            , [activity_id]
            , [gender]
            , [birthday]
            , [age]
            , [ethnicity_code]
            , [occupation_code]
            , [maritalstatus_code]
            , [norwood]
            , [ludwig]
            , [creation_date]
            , [created_by_user_code]
            , [updated_date]
            , [updated_by_user_code]
            , [performer]
            , [price_quoted]
            , [solution_offered]
            , [no_sale_reason]
            )
    VALUES  (
              @ActivityDemographicID
            , @ActivityID
            , @Gender
            , @Birthday
            , @Age
            , @EthnicityCode
            , @OccupationCode
            , @MaritalStatusCode
            , @Norwood
            , @Ludwig
            , GETDATE()
            , @CenterID
            , GETDATE()
            , @CenterID
            , @Performer
            , @PriceQuoted
            , @SolutionOffered
            , @NoSaleReason )

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END


	-- ONCD_ACTIVITY_CONTACT.
    DECLARE @ActivityContactID VARCHAR(10)

    EXEC [HCM].[dbo].[onc_create_primary_key] @key_length = 10, @table_name = 'oncd_activity_contact', @column_name = 'activity_contact_id',
      @primary_key = @ActivityContactID OUTPUT, @suffix = 'ITC'

    INSERT  INTO [HCM].[dbo].[oncd_activity_contact]
            (
              [activity_contact_id]
            , [activity_id]
            , [contact_id]
            , [primary_flag]
            , [sort_order]
            , [created_by_user_code]
            , [creation_date]
            , [updated_by_user_code]
            , [updated_date]
            )
    VALUES  (
              @ActivityContactID
            , @ActivityID
            , @ContactID
            , 'Y'
            , 0
            , @CenterID
            , GETDATE()
            , @CenterID
            , GETDATE() )

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END


	-- CSTD_CONTACT_COMPLETION.
    DECLARE @ContactCompletionID VARCHAR(10)
    DECLARE @SalesTypeCode INT
    DECLARE @SalesType VARCHAR(50)
    DECLARE @SalesTypeDescription VARCHAR(50)
    DECLARE @ShowNoShow CHAR(1)
    DECLARE @SaleNoSale CHAR(1)
    DECLARE @ContractAmount MONEY
    DECLARE @ClientNumber VARCHAR(50)
    DECLARE @InitialPayment MONEY
    DECLARE @Systems INT
    DECLARE @Services INT
    DECLARE @Graphs INT
    DECLARE @Reschedule CHAR(1)
    DECLARE @RescheduleDate DATETIME
    DECLARE @Comments VARCHAR(50)
    DECLARE @SurgeryOffered CHAR(1)
    DECLARE @ReferredToDoctor CHAR(1)
    DECLARE @SurgeryConsultation CHAR(1)
    DECLARE @HeadSize INT
    DECLARE @HairLength INT
    DECLARE @LengthPrice MONEY
    DECLARE @BasePrice MONEY
    DECLARE @DiscountAmount MONEY
    DECLARE @DiscountPercent VARCHAR(50)
    DECLARE @BalanceAmount MONEY
    DECLARE @BalancePercent VARCHAR(50)
    DECLARE @DiscountMarkup VARCHAR(50)
    DECLARE @AppointmentDate DATETIME
    DECLARE @StatusLine VARCHAR(500)

    EXEC [HCM].[dbo].[onc_create_primary_key] @key_length = 10, @table_name = 'cstd_contact_completion', @column_name = 'contact_completion_id',
      @primary_key = @ContactCompletionID OUTPUT, @suffix = 'ITC'

    IF @ResultCode = 'SHOWNOSALE'
      BEGIN
        SET @SalesTypeCode = 0
        SET @SalesType = ''
        SET @SalesTypeDescription = 'Select Sales Type'
        SET @ShowNoShow = 'S'
        SET @SaleNoSale = 'N'
        SET @ContractAmount = NULL
        SET @ClientNumber = NULL
        SET @InitialPayment = NULL
        SET @Systems = NULL
        SET @Services = NULL
        SET @Graphs = NULL
        SET @Reschedule = 'N'
        SET @RescheduleDate = NULL
        SET @Comments = ''
        SET @SurgeryOffered = 'Y'
        SET @ReferredToDoctor = 'N'
        SET @SurgeryConsultation = 'N'
        SET @HeadSize = NULL
        SET @HairLength = NULL
        SET @LengthPrice = NULL
        SET @BasePrice = NULL
        SET @DiscountAmount = NULL
        SET @DiscountPercent = NULL
        SET @BalanceAmount = NULL
        SET @BalancePercent = NULL
        SET @DiscountMarkup = NULL
        SET @AppointmentDate = GETDATE()
        SET @StatusLine = 'Show, No Sale, Solution Offered: Surgery'
      END

    IF @ResultCode = 'SHOWSALE'
      BEGIN
        SET @SalesTypeCode = 4
        SET @SalesType = 'SUR'
        SET @SalesTypeDescription = 'Surgery'
        SET @ShowNoShow = 'S'
        SET @SaleNoSale = 'S'
        SET @ContractAmount = 0
        SET @ClientNumber = ''
        SET @InitialPayment = 0
        SET @Systems = 0
        SET @Services = 0
        SET @Graphs = 0
        SET @Reschedule = NULL
        SET @RescheduleDate = NULL
        SET @Comments = NULL
        SET @SurgeryOffered = NULL
        SET @ReferredToDoctor = NULL
        SET @SurgeryConsultation = 'N'
        SET @HeadSize = 0
        SET @HairLength = 0
        SET @LengthPrice = 0
        SET @BasePrice = 0
        SET @DiscountAmount = 0
        SET @DiscountPercent = ''
        SET @BalanceAmount = 0
        SET @BalancePercent = ''
        SET @DiscountMarkup = ''
        SET @AppointmentDate = GETDATE()
        SET @StatusLine = 'Show, Sale, Surgery, Performer: ' + @Performer
      END

    INSERT  INTO [HCM].[dbo].[cstd_contact_completion]
            (
              [contact_completion_id]
            , [company_id]
            , [created_by_user_code]
            , [updated_by_user_code]
            , [contact_id]
            , [activity_id]
            , [sale_type_code]
            , [sale_type_description]
            , [show_no_show_flag]
            , [sale_no_sale_flag]
            , [contract_amount]
            , [client_number]
            , [initial_payment]
            , [systems]
            , [services]
            , [number_of_graphs]
            , [status_line]
            , [head_size]
            , [hair_length]
            , [length_Price]
            , [base_price]
            , [discount_amount]
            , [discount_percentage]
            , [balance_amount]
            , [balance_percentage]
            , [discount_markup_flag]
            , [date_saved]
            , [original_appointment_date]
            , [creation_date]
            , [updated_date]
            , [comment]
            , [surgery_offered_flag]
            , [referred_to_doctor_flag]
            , [surgery_consultation_flag]
            , [reschedule_flag]
			, [date_rescheduled]
            )
    VALUES  (
              @ContactCompletionID
            , @CenterID
            , @CenterID
            , @CenterID
            , @ContactID
            , @ActivityID
            , @SalesTypeCode
            , @SalesTypeDescription
            , @ShowNoShow
            , @SaleNoSale
            , @ContractAmount
            , @ClientNumber
            , @InitialPayment
            , @Systems
            , @Services
            , @Graphs
            , @StatusLine
            , @HeadSize
            , @HairLength
            , @LengthPrice
            , @BasePrice
            , @DiscountAmount
            , @DiscountPercent
            , @BalanceAmount
            , @BalancePercent
            , @DiscountMarkup
            , GETDATE()
            , GETDATE()
            , GETDATE()
            , GETDATE()
            , @Comments
            , @SurgeryOffered
            , @ReferredToDoctor
            , @SurgeryConsultation
            , @Reschedule
            , @RescheduleDate )

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END


	-- ONCD_CONTACT.
    UPDATE  [HCM].[dbo].[oncd_contact]
    SET     [surgery_consultation_flag] = 'N'
    WHERE   [contact_id] = @ContactID

    IF @@ERROR <> 0
      BEGIN
        ROLLBACK TRANSACTION
        RETURN
      END
  END

COMMIT TRANSACTION
GO
