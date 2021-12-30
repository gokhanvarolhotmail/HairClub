/* CreateDate: 09/22/2008 15:03:27.563 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CompletionNoShow
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
EXEC spApp_TREConsultations_CompletionNoShow
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CompletionNoShow]
(
	@CompletionID VARCHAR(50),
	@CenterNumber VARCHAR(50),
	@CreatedBy VARCHAR(50),
	@UpdatedBy VARCHAR(50),
	@ContactID VARCHAR(50),
	@ActivityID VARCHAR(50),
	@ShowNoShow CHAR(1),
	@SaleNoSale CHAR(1),
	@StatusLine VARCHAR(5000),
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
			, [show_no_show_flag]
			, [sale_no_sale_flag]
			, [status_line]
			, [sale_type_code]
			, [sale_type_description]
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
			, @ShowNoShow
			, @SaleNoSale
			, @StatusLine
			, 0
			, 'No Show'
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
