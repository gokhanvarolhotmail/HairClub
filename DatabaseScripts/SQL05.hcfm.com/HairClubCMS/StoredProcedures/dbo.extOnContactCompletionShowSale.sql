/* CreateDate: 12/11/2012 14:57:18.617 , ModifyDate: 12/11/2012 14:57:18.617 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCompletionShowSale

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CompletionShowSale

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCompletionShowSale
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCompletionShowSale]
(
	@CenterNumber varchar(50),
	@CreatedBy varchar(50),
	@UpdatedBy varchar(50),
	@ContactID varchar(50),
	@ActivityID varchar(50),
	@SalesTypeCode int,
	@SalesType varchar(50),
	@SalesTypeDescription varchar(50),
	@ShowNoShow CHAR(1),
	@SaleNoSale CHAR(1),
	@ContractAmount MONEY,
	@ClientNumber varchar(50),
	@InitialPayment MONEY,
	@Systems int,
	@Services int,
	@Graphs int,
	@StatusLine varchar(5000),
	@HeadSize varchar(50),
	@HairLength varchar(50),
	@LengthPrice MONEY,
	@BasePrice MONEY,
	@DiscountAmount MONEY,
	@DiscountPercent varchar(50),
	@BalanceAmount MONEY,
	@BalancePercent varchar(50),
	@DiscountMarkup varchar(50),
	@OriginalAppointmentDate datetime
)
AS
BEGIN TRANSACTION

	DECLARE @CompletionID varchar(25)

	EXEC extOnContactCreatePrimaryKey 10, 'cstd_contact_completion', 'contact_completion_id', @CompletionID OUTPUT, 'ONC'

	IF EXISTS (SELECT activity_id FROM HCMSkylineTest..cstd_contact_completion WHERE activity_id = @ActivityID AND contact_id = @ContactID)
	  BEGIN
		DELETE FROM HCMSkylineTest..cstd_contact_completion
		WHERE activity_id = @ActivityID AND contact_id = @ContactID

		IF @@ERROR <> 0
		  BEGIN
			ROLLBACK TRANSACTION
			RETURN
		  END
	  END

	INSERT  intO HCMSkylineTest..cstd_contact_completion (contact_completion_id, company_id, created_by_user_code, updated_by_user_code, contact_id, activity_id, sale_type_code, sale_type_description, show_no_show_flag, sale_no_sale_flag, contract_amount, client_number, initial_payment, systems, services, number_of_graphs, status_line, head_size, hair_length, length_Price, base_price, discount_amount, discount_percentage, balance_amount, balance_percentage, discount_markup_flag, date_saved, original_appointment_date, creation_date, updated_date)
		VALUES (@CompletionID, @CenterNumber, @CreatedBy, @UpdatedBy, @ContactID, @ActivityID, @SalesTypeCode, @SalesTypeDescription, @ShowNoShow, @SaleNoSale, @ContractAmount, @ClientNumber, @InitialPayment, @Systems, @Services, @Graphs, @StatusLine, CASE WHEN @SalesType IN ( 'EXT', 'SUR' ) THEN 'N/A' ELSE @HeadSize END, CASE WHEN @SalesType IN ( 'EXT', 'SUR' ) THEN 'N/A' ELSE @HairLength END, CASE WHEN @SalesType IN ( 'EXT', 'SUR' ) THEN 0 ELSE @LengthPrice END, @BasePrice, @DiscountAmount, @DiscountPercent, @BalanceAmount, @BalancePercent, @DiscountMarkup, GETDATE(), @OriginalAppointmentDate, GETDATE(), GETDATE() )

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
