/* CreateDate: 12/11/2012 14:57:18.593 , ModifyDate: 12/11/2012 14:57:18.593 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCompletionNoShow

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CompletionNoShow

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCompletionNoShow
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCompletionNoShow]
(
	@CompletionID varchar(50),
	@CenterNumber varchar(50),
	@CreatedBy varchar(50),
	@UpdatedBy varchar(50),
	@ContactID varchar(50),
	@ActivityID varchar(50),
	@ShowNoShow char(1),
	@SaleNoSale char(1),
	@StatusLine varchar(5000),
	@OriginalAppointmentDate datetime
)
AS
BEGIN TRANSACTION

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

	INSERT intO HCMSkylineTest..cstd_contact_completion (contact_completion_id, company_id, created_by_user_code, updated_by_user_code, contact_id, activity_id, show_no_show_flag, sale_no_sale_flag, status_line, sale_type_code, sale_type_description, date_saved, original_appointment_date, creation_date, updated_date)
		VALUES (@CompletionID, @CenterNumber, @CreatedBy, @UpdatedBy, @ContactID, @ActivityID, @ShowNoShow, @SaleNoSale, @StatusLine, 0, 'No Show', GETDATE(), @OriginalAppointmentDate, GETDATE(), GETDATE() )

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
