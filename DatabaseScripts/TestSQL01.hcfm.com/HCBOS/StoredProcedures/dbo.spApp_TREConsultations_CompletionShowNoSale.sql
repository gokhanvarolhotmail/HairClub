/* CreateDate: 09/22/2008 15:03:36.593 , ModifyDate: 01/25/2010 08:11:31.807 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CompletionShowNoSale
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
--
-- 09/28/2009 - DL	--> Moved oncd_contact update to the spApp_TREConsultations_CompleteShow procedure
--					--> SHNOBUYCAL Trigger was being bypassed because the contact was being updated AFTER
--					--> the activity.
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CompletionShowNoSale
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CompletionShowNoSale]
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
	@RescheduleFlag CHAR(1),
	@DateRescheduled DATETIME,
	@Comment VARCHAR(500),
	@SurgeryOffered CHAR(1),
	@ReferredToDoctor CHAR(1),
	@SurgeryConsultation CHAR(1),
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
			, [sale_type_code]
			, [sale_type_description]
			, [show_no_show_flag]
			, [sale_no_sale_flag]
			, [reschedule_flag]
			, [date_rescheduled]
			, [comment]
			, [surgery_offered_flag]
			, [referred_to_doctor_flag]
			, [surgery_consultation_flag]
			, [status_line]
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
			, @RescheduleFlag
			, @DateRescheduled
			, @Comment
			, @SurgeryOffered
			, @ReferredToDoctor
			, @SurgeryConsultation
			, @StatusLine
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
