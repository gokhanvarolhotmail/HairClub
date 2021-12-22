/* CreateDate: 09/22/2008 15:03:53.437 , ModifyDate: 01/25/2010 13:43:09.327 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			spApp_TREConsultations_CreateActivity
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
-- 06/02/2009 - DL	--> Added [source_code] for INHOUSE activities.
-- 07/30/2009 - DL	--> Changed the @CompletedBy parameter to @User.
-- 07/30/2009 - DL	--> Changed the [completed_by_user_code], [completion_date], [completion_time]
--						column values to NULL
-- 10/07/2009 - DL	--> Changed the [source_code] column value on [oncd_activity] to NULL
--
-- 10/07/2009 - DL	--> Added ActivitySource parameter
-- ----------------------------------------------------------------------------------------------
--
Sample Execution:
--
EXEC spApp_TREConsultations_CreateActivity
================================================================================================*/
CREATE PROCEDURE [dbo].[spApp_TREConsultations_CreateActivity]
(
	@ActivityID VARCHAR(50),
	@ActionCode VARCHAR(50),
	@ResultCode VARCHAR(50),
	@ActivityType VARCHAR(50),
	@Description VARCHAR(50),
	@ContactID VARCHAR(50),
	@ActivityContactID VARCHAR(50),
	@ActivityUserID VARCHAR(50),
	@User VARCHAR(50),
	@ActivitySource VARCHAR(50)
)
AS
BEGIN TRANSACTION

	SET @ResultCode = NULL

	-- ONCD ACTIVITY.
	INSERT  INTO [HCM].[dbo].[oncd_activity]
			(
			 [activity_id]
			,[due_date]
			,[start_time]
			,[action_code]
			,[result_code]
			,[completed_by_user_code]
			,[completion_date]
			,[completion_time]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			,[description]
			,[cst_activity_type_code]
			,[source_code]
			)
	VALUES  (
			 @ActivityID
			,CAST(CONVERT(VARCHAR(11), GETDATE(), 101) AS DATETIME)
			,(GETDATE() - CAST(ROUND(CAST(GETDATE() AS FLOAT), 0, 1) AS DATETIME))
			,@ActionCode
			,@ResultCode
			,NULL
			,NULL
			,NULL
			,@User
			,GETDATE()
			,@User
			,GETDATE()
			,@Description
			,@ActivityType
			,CASE WHEN @ActionCode = 'INHOUSE' THEN @ActivitySource ELSE NULL END )

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD ACTIVITY CONTACT.
	INSERT  INTO [HCM].[dbo].[oncd_activity_contact]
			(
			 [activity_contact_id]
			,[activity_id]
			,[contact_id]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			)
	VALUES  (
			 @ActivityContactID
			,@ActivityID
			,@ContactID
			,'Y'
			,0
			,@User
			,GETDATE()
			,@User
			,GETDATE())

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

	-- ONCD ACTIVITY USER.
	INSERT  INTO [HCM].[dbo].[oncd_activity_user]
			(
			 [activity_user_id]
			,[activity_id]
			,[user_code]
			,[primary_flag]
			,[sort_order]
			,[created_by_user_code]
			,[creation_date]
			,[updated_by_user_code]
			,[updated_date]
			)
	VALUES  (
			 @ActivityUserID
			,@ActivityID
			,@User
			,'Y'
			,0
			,@User
			,GETDATE()
			,@User
			,GETDATE())

	IF @@ERROR <> 0
	  BEGIN
		ROLLBACK TRANSACTION
		RETURN
	  END

COMMIT TRANSACTION
GO
