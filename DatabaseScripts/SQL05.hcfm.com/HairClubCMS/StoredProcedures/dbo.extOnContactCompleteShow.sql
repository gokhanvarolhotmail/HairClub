/* CreateDate: 12/11/2012 14:57:18.563 , ModifyDate: 12/11/2012 14:57:18.563 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCompleteShow

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CompleteShow

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCompleteShow
==============================================================================
*/
CREATE PROCEDURE [dbo].[extOnContactCompleteShow]
(
	@ActivityID varchar(50),
	@ContactID varchar(50),
	@SurgeryConsultation char(1),
	@CompletedBy varchar(50)
)
AS
BEGIN TRANSACTION

	UPDATE  HCMSkylineTest..oncd_contact
	SET surgery_consultation_flag = @SurgeryConsultation
	WHERE contact_id = @ContactID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	UPDATE  HCMSkylineTest..oncd_activity
	SET result_code = 'SHOWNOSALE'
	, completion_date = CAST(CONVERT(varchar(11), GETDATE(), 101) AS datetime)
	, completion_time = (GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT), 0, 1) AS datetime))
	, completed_by_user_code = @CompletedBy
	, updated_date = GETDATE()
	, updated_by_user_code = @CompletedBy
	WHERE activity_id = @ActivityID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
