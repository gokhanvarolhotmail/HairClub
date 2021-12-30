/* CreateDate: 01/23/2017 15:39:16.897 , ModifyDate: 05/02/2017 13:10:00.640 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSCreateActivityForSpecificTime

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		01/19/2017

LAST REVISION DATE: 	01/19/2017

==============================================================================
DESCRIPTION:	Create Activity for Specific Time called by the HairClubCMS DB
==============================================================================
NOTES:
		* 01/19/2017 MVT - Created proc
		* 05/02/2017 DSL - Added Action Codes of BOSLEAD & BOSCLIENT to Activity creation (WO# 137511)
==============================================================================
SAMPLE EXECUTION:
EXEC extHairClubCMSCreateActivityForSpecificTime '86QR6ETONC', 'INHOUSE', NULL, 'INBOUND', 'INHOUSE', '0MU1O2MONC', 203, 'REFERAFRND', 'EST'
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSCreateActivityForSpecificTime]
(
	  @ActivityID varchar(25) output,
      @ActionCode varchar(50),
      @ResultCode varchar(50),
      @ActivityType varchar(50),
      @Description varchar(50),
      @ContactID varchar(50),
      @User varchar(50),
      @ActivitySource varchar(50),
	  @TimeZoneCode varchar(4),
	  @Start datetime
)
AS

SET XACT_ABORT ON

BEGIN TRANSACTION

	  DECLARE @p_User nchar(20) = CAST(@User AS nchar(20))

      SET @ResultCode = NULL

      DECLARE @ActivityContactID varchar(25)
      DECLARE @ActivityUserID varchar(25)
	  DECLARE @ActivityCompanyID varchar(25)
	  DECLARE @CompanyID varchar(25)

	  SET @CompanyID = (SELECT OC.company_id FROM oncd_company OC WHERE OC.cst_center_number = @p_User)

	  IF @ActivityID IS NULL OR LTRIM(RTRIM(@ActivityID)) = ''
	  BEGIN
		EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity', 'activity_id', @ActivityID OUTPUT, 'ONC'
	  END

      EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity_contact', 'activity_contact_id', @ActivityContactID OUTPUT, 'ONC'
      EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity_user', 'activity_user_id', @ActivityUserID OUTPUT, 'ONC'
	  EXEC extHairClubCMSCreatePrimaryKey 10, 'oncd_activity_company', 'activity_company_id', @ActivityCompanyID OUTPUT, 'ONC'

      -- ONCD ACTIVITY.
      INSERT  intO oncd_activity (activity_id, due_date, start_time, action_code, result_code, completed_by_user_code, completion_date, completion_time, created_by_user_code, creation_date, updated_by_user_code, updated_date, [description], cst_activity_type_code, source_code, cst_time_zone_code)
            VALUES (@ActivityID, CAST(CONVERT(varchar(11),  @Start,  101) AS datetime), CAST(CONVERT(TIME,@Start) AS DateTime), @ActionCode, @ResultCode, NULL, NULL, NULL, @p_User, GETDATE(), @p_User, GETDATE(), @Description, @ActivityType, CASE WHEN @ActionCode IN ( 'INHOUSE', 'BOSLEAD', 'BOSCLIENT' ) THEN @ActivitySource ELSE NULL END, @TimeZoneCode )

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

      -- ONCD ACTIVITY COMPANY.
      INSERT INTO oncd_activity_company ( activity_company_id, activity_id, company_id, assignment_date, attendance, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag )
            VALUES (@ActivityCompanyID, @ActivityID, @CompanyID, GETDATE(), 'N', 0, GETDATE(), @p_User, GETDATE(), @p_User, 'Y')

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
