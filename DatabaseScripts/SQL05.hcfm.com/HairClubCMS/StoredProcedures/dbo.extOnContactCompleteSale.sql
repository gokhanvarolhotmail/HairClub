/* CreateDate: 12/11/2012 14:57:18.553 , ModifyDate: 12/11/2012 14:57:18.553 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCompleteSale

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Dominic Leiba

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 7/29/2008

LAST REVISION DATE: 	 5/7/2010

==============================================================================
DESCRIPTION:	Find Leads from OnContact database
==============================================================================
NOTES:
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CompleteSale

==============================================================================
SAMPLE EXECUTION:
EXEC extOnContactCompleteSale
==============================================================================
*/
CREATE PROCEDURE [dbo].[extOnContactCompleteSale]
(
	@ActivityID varchar(50),
	@ContactID varchar(50),
	@CompletedBy varchar(50)
)
AS
BEGIN TRANSACTION

	-- ONCD ACTIVITY.
	UPDATE  HCMSkylineTest..oncd_activity
	SET result_code = 'SHOWSALE'
	, completion_date = CAST(CONVERT(varchar(11), GETDATE(), 101) AS datetime)
	, completion_time = (GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT), 0, 1) AS datetime))
	, completed_by_user_code = @CompletedBy
	, updated_date = GETDATE()
	, updated_by_user_code = @CompletedBy
	WHERE   [activity_id] = @ActivityID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD CONTACT.
	UPDATE  HCMSkylineTest..oncd_contact
	SET cst_complete_sale = 1
	WHERE contact_id = @ContactID

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
