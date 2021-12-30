/* CreateDate: 12/11/2012 14:57:18.607 , ModifyDate: 12/11/2012 14:57:18.607 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCompletionShowNoSale

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CompletionShowNoSale

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCompletionShowNoSale
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCompletionShowNoSale]
(
	@CenterNumber varchar(50),
	@CreatedBy varchar(50),
	@UpdatedBy varchar(50),
	@ContactID varchar(50),
	@ActivityID varchar(50),
	@SalesTypeCode int,
	@SalesType varchar(50),
	@SalesTypeDescription varchar(50),
	@ShowNoShow char(1),
	@SaleNoSale char(1),
	@RescheduleFlag char(1),
	@DateRescheduled datetime,
	@Comment varchar(500),
	@SurgeryOffered char(1),
	@ReferredToDoctor char(1),
	@SurgeryConsultation char(1),
	@StatusLine varchar(5000),
	@OriginalAppointmentDate datetime
)
AS
BEGIN TRANSACTION

	DECLARE @CompletionID varchar(25)

	EXEC extOnContactCreatePrimaryKey 10, 'cstd_contact_completion', 'contact_completion_id', @CompletionID OUTPUT, 'ONC'

	IF EXISTS (SELECT activity_id FROM HCMSkylineTest..cstd_contact_completion WHERE activity_id = @ActivityID AND contact_id = @ContactID)
	  BEGIN
		DELETE  FROM HCMSkylineTest..cstd_contact_completion
		WHERE   activity_id = @ActivityID AND contact_id = @ContactID

		IF @@ERROR <> 0
		  BEGIN
			ROLLBACK TRANSACTION
			RETURN
		  END
	  END

	INSERT  intO HCMSkylineTest..cstd_contact_completion (contact_completion_id, company_id, created_by_user_code, updated_by_user_code, contact_id, activity_id, sale_type_code, sale_type_description, show_no_show_flag, sale_no_sale_flag, reschedule_flag, date_rescheduled, comment, surgery_offered_flag, referred_to_doctor_flag, surgery_consultation_flag, status_line, date_saved, original_appointment_date, creation_date, updated_date)
		VALUES (@CompletionID, @CenterNumber, @CreatedBy, @UpdatedBy, @ContactID, @ActivityID, @SalesTypeCode, @SalesTypeDescription, @ShowNoShow, @SaleNoSale, @RescheduleFlag, @DateRescheduled, @Comment, @SurgeryOffered, @ReferredToDoctor, @SurgeryConsultation, @StatusLine, GETDATE(), @OriginalAppointmentDate, GETDATE(), GETDATE() )

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
