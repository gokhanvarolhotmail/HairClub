/* CreateDate: 12/11/2012 14:57:18.627 , ModifyDate: 12/11/2012 14:57:18.627 */
GO
/*
==============================================================================
PROCEDURE:				extOnContactCreateActivity

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
		* 5/7/2010 PRM - Copied from TRE stored proc: spApp_TREConsultations_CreateActivity

==============================================================================
SAMPLE EXECUTION:
EXEC spApp_TREConsultations_CreateActivity
==============================================================================
*/

CREATE PROCEDURE [dbo].[extOnContactCreateActivity]
(
	  @ActivityID varchar(25),
      @ActionCode varchar(50),
      @ResultCode varchar(50),
      @ActivityType varchar(50),
      @Description varchar(50),
      @ContactID varchar(50),
      @User varchar(50),
      @ActivitySource varchar(50)
)
AS
BEGIN TRANSACTION

      SET @ResultCode = NULL

      DECLARE @ActivityContactID varchar(25)
      DECLARE @ActivityUserID varchar(25)

      EXEC extOnContactCreatePrimaryKey 10, 'oncd_activity_contact', 'activity_contact_id', @ActivityContactID OUTPUT, 'ONC'
      EXEC extOnContactCreatePrimaryKey 10, 'oncd_activity_user', 'activity_user_id', @ActivityUserID OUTPUT, 'ONC'

      -- ONCD ACTIVITY.
      INSERT  intO HCMSkylineTest..oncd_activity (activity_id, due_date, start_time, action_code, result_code, completed_by_user_code, completion_date, completion_time, created_by_user_code, creation_date, updated_by_user_code, updated_date, [description], cst_activity_type_code, source_code)
            VALUES (@ActivityID, CAST(CONVERT(varchar(11),  GETDATE(),  101) AS datetime), (GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT),  0, 1) AS datetime)), @ActionCode, @ResultCode, NULL, NULL, NULL, @User, GETDATE(), @User, GETDATE(), @Description, @ActivityType, CASE WHEN @ActionCode = 'INHOUSE' THEN @ActivitySource ELSE NULL END )

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD ACTIVITY CONTACT.
      INSERT  INTO HCMSkylineTest..oncd_activity_contact (activity_contact_id, activity_id, contact_id, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
            VALUES (@ActivityContactID, @ActivityID, @ContactID, 'Y', 0, @User, GETDATE(), @User, GETDATE())

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD ACTIVITY USER.
      INSERT  intO HCMSkylineTest..oncd_activity_user (activity_user_id, activity_id, user_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
            VALUES (@ActivityUserID, @ActivityID, @User, 'Y', 0, @User, GETDATE(), @User, GETDATE())

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

COMMIT TRANSACTION
GO
