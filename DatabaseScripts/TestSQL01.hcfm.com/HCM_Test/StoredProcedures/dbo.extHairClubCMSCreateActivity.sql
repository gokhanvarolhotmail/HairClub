/* CreateDate: 08/17/2015 15:31:38.730 , ModifyDate: 05/02/2017 13:06:30.530 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSCreateActivity

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		08/10/2015

LAST REVISION DATE: 	08/10/2015

==============================================================================
DESCRIPTION:	Create Activity called by the HairClubCMS DB
==============================================================================
NOTES:
		* 08/10/2015 MVT - Created proc
		* 09/29/2016 MVT - Added Time Zone Code when creating Activity (TFS #7971)
		* 05/02/2017 DSL - Added Action Codes of BOSLEAD & BOSCLIENT to Activity creation (WO# 137511)
==============================================================================
SAMPLE EXECUTION:
EXEC extHairClubCMSCreateActivity
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSCreateActivity]
(
	  @ActivityID varchar(25) output,
      @ActionCode varchar(50),
      @ResultCode varchar(50),
      @ActivityType varchar(50),
      @Description varchar(50),
      @ContactID varchar(50),
      @User varchar(50),
      @ActivitySource varchar(50),
	  @TimeZoneCode varchar(4)
)
AS

SET XACT_ABORT ON

BEGIN TRANSACTION

	  DECLARE @p_User nchar(20) = CAST(@User AS nchar(20))

      SET @ResultCode = NULL

      DECLARE @ActivityContactID varchar(25)
      DECLARE @ActivityUserID varchar(25)

	  IF @ActivityID IS NULL OR LTRIM(RTRIM(@ActivityID)) = ''
	  BEGIN
		EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity', 'activity_id', @ActivityID OUTPUT, 'ONC'
	  END

      EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity_contact', 'activity_contact_id', @ActivityContactID OUTPUT, 'ONC'
      EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity_user', 'activity_user_id', @ActivityUserID OUTPUT, 'ONC'

      -- ONCD ACTIVITY.
      INSERT  intO oncd_activity (activity_id, due_date, start_time, action_code, result_code, completed_by_user_code, completion_date, completion_time, created_by_user_code, creation_date, updated_by_user_code, updated_date, [description], cst_activity_type_code, source_code, cst_time_zone_code)
            VALUES (@ActivityID, CAST(CONVERT(varchar(11),  GETDATE(),  101) AS datetime), CAST(CONVERT(TIME,GETDATE()) AS DateTime), @ActionCode, @ResultCode, NULL, NULL, NULL, @p_User, GETDATE(), @p_User, GETDATE(), @Description, @ActivityType, CASE WHEN @ActionCode IN ( 'INHOUSE', 'BOSLEAD', 'BOSCLIENT' ) THEN @ActivitySource ELSE NULL END, @TimeZoneCode )

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD ACTIVITY CONTACT.
      INSERT  INTO oncd_activity_contact (activity_contact_id, activity_id, contact_id, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
            VALUES (@ActivityContactID, @ActivityID, @ContactID, 'Y', 0, @p_User, GETDATE(), @p_User, GETDATE())

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

      -- ONCD ACTIVITY USER.
      INSERT  INTO oncd_activity_user (activity_user_id, activity_id, user_code, primary_flag, sort_order, created_by_user_code, creation_date, updated_by_user_code, updated_date)
            VALUES (@ActivityUserID, @ActivityID, @User, 'Y', 0, @p_User, GETDATE(), @p_User, GETDATE())

      IF @@ERROR <> 0
        BEGIN
            ROLLBACK TRANSACTION
            RETURN
        END

COMMIT TRANSACTION
GO
