/* CreateDate: 09/22/2008 15:03:45.267 , ModifyDate: 01/25/2010 08:11:31.823 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CompletionShowSale
-- Procedure Description:
--
-- Created By:				Dominic Leiba
-- Implemented By:			Dominic Leiba
-- Last Modified By:		Dominic Leiba
--
-- Date Created:			7/14/2008
-- Date Implemented:		7/14/2008
-- Date Last Modified:		7/14/2008
--
-- Destination Server:		HCSQL3\SQL2005
-- Destination Database:	HCM
-- Related Application:		The Right Experience
--
-- ----------------------------------------------------------------------------------------------
-- Notes:
--
-- 05/12/2009 - DL	--> spApp_TREConsultations_DeleteContactCompletion was removed from the UI
					--> because it was doing the same thing as the following code:
					--> IF EXISTS ( SELECT  [activity_id]
									FROM    [HCM].[dbo].[cstd_contact_completion]
									WHERE   [activity_id] = @ActivityID
											AND [contact_id] = @ContactID )
						  BEGIN
							DELETE  FROM [HCM].[dbo].[cstd_contact_completion]
							WHERE   [activity_id] = @ActivityID
									AND [contact_id] = @ContactID

							IF @@ERROR <> 0
							  BEGIN
								ROLLBACK TRANSACTION
								RETURN
							  END
						  END
					--> Added the following line of code to the DELETE FROM statement:
					--> AND [contact_id] = @ContactID
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CompletionShowSale
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CompletionShowSale]
(
	@CompletionID VARCHAR(50),
	@CenterNumber VARCHAR(50),
	@CreatedBy VARCHAR(50),
	@UpdatedBy VARCHAR(50),
	@ContactID VARCHAR(50),
	@ActivityID VARCHAR(50),
	@SalesTypeCode INT,
	@SalesType VARCHAR(50),
	@SalesTypeDescription VARCHAR(50),
	@ShowNoShow CHAR(1),
	@SaleNoSale CHAR(1),
	@ContractAmount MONEY,
	@ClientNumber VARCHAR(50),
	@InitialPayment MONEY,
	@Systems INT,
	@Services INT,
	@Graphs INT,
	@StatusLine VARCHAR(5000),
	@HeadSize VARCHAR(50),
	@HairLength VARCHAR(50),
	@LengthPrice MONEY,
	@BasePrice MONEY,
	@DiscountAmount MONEY,
	@DiscountPercent VARCHAR(50),
	@BalanceAmount MONEY,
	@BalancePercent VARCHAR(50),
	@DiscountMarkup VARCHAR(50),
	@OriginalAppointmentDate DATETIME
)
AS
BEGIN TRANSACTION

	IF EXISTS ( SELECT  [activity_id]
				FROM    [HCM].[dbo].[cstd_contact_completion]
				WHERE   [activity_id] = @ActivityID
						AND [contact_id] = @ContactID )
	  BEGIN
		DELETE  FROM [HCM].[dbo].[cstd_contact_completion]
		WHERE   [activity_id] = @ActivityID
				AND [contact_id] = @ContactID

		IF @@ERROR <> 0
		  BEGIN
			ROLLBACK TRANSACTION
			RETURN
		  END
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
			)
	VALUES  (
			  @CompletionID
			, @CenterNumber
			, @CreatedBy
			, @UpdatedBy
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
			, CASE WHEN @SalesType IN ( 'EXT', 'SUR' ) THEN 'N/A'
				   ELSE @HeadSize
			  END
			, CASE WHEN @SalesType IN ( 'EXT', 'SUR' ) THEN 'N/A'
				   ELSE @HairLength
			  END
			, CASE WHEN @SalesType IN ( 'EXT', 'SUR' ) THEN 0
				   ELSE @LengthPrice
			  END
			, @BasePrice
			, @DiscountAmount
			, @DiscountPercent
			, @BalanceAmount
			, @BalancePercent
			, @DiscountMarkup
			, GETDATE()
			, @OriginalAppointmentDate
			, GETDATE()
			, GETDATE() )

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
