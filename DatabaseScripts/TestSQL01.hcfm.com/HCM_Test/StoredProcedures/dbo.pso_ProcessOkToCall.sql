/* CreateDate: 03/22/2016 11:28:55.037 , ModifyDate: 03/22/2016 11:28:55.037 */
GO
-- =============================================
-- Author:		Workwise, LLC - MJW
-- Create date: 2016-02-19
-- Description:	Process OkToCall logic for contact phone
-- =============================================
CREATE PROCEDURE [dbo].[pso_ProcessOkToCall]
	@phone_number nvarchar(30),
	@ok_to_call_flag nchar(1),
	@contact_id	  nchar(10),
	@user_code	  nchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	IF @phone_number IS NULL return

	IF @ok_to_call_flag = 'Y'
	BEGIN
		--Hard
		IF (SELECT dnc_flag FROM cstd_phone_dnc_wireless WHERE phonenumber = @phone_number) = 'Y'
		BEGIN
			UPDATE cstd_phone_dnc_wireless SET dnc_flag = 'N', dnc_date = GETDATE(), dnc_flag_user_code = @user_code
				WHERE phonenumber = @phone_number AND dnc_flag = 'Y'

			IF @contact_id IS NOT NULL
				UPDATE oncd_contact SET cst_do_not_call = 'N', updated_date = GETDATE(), updated_by_user_code = @user_code
					WHERE contact_id = @contact_id AND cst_do_not_call = 'Y'
		END

		--Soft
		IF (SELECT ebr_dnc_flag FROM cstd_phone_dnc_wireless WHERE phonenumber = @phone_number) = 'Y'
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM oncd_activity a WITH (NOLOCK) INNER JOIN oncd_activity_contact ac WITH (NOLOCK) ON ac.activity_id = a.activity_id WHERE ac.contact_id = @contact_id AND a.action_code = 'INCALL' AND a.result_code = 'EBREPC' AND a.creation_date >= CONVERT(nchar(10),GETDATE(),121))
			BEGIN
				DECLARE @pk nchar(10)
				DECLARE @activity_id nchar(10)
				EXEC onc_create_primary_key 10, 'oncd_activity', 'activity_id', @activity_id OUTPUT
				INSERT INTO oncd_activity (activity_id, action_code, description, result_code, due_date, start_time, creation_date, created_by_user_code, completion_date, completed_by_user_code, updated_date, updated_by_user_code)
					VALUES (@activity_id, 'INCALL', 'Inbound Call', 'EBREPC', GETDATE(), GETDATE(), GETDATE(), @user_code, GETDATE(), @user_code, GETDATE(), @user_code)

				EXEC onc_create_primary_key 10, 'oncd_activity_contact', 'activity_contact_id', @pk OUTPUT
				INSERT INTO oncd_activity_contact (activity_contact_id, activity_id, contact_id, assignment_date, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
					VALUES (@pk, @activity_id, @contact_id, GETDATE(), 0, GETDATE(), @user_code, GETDATE(), @user_code, 'Y')

				EXEC onc_create_primary_key 10, 'oncd_activity_user', 'activity_user_id', @pk OUTPUT
				INSERT INTO oncd_activity_user (activity_user_id, activity_id, user_code, assignment_date, sort_order, creation_date, created_by_user_code, updated_date, updated_by_user_code, primary_flag)
					VALUES (@pk, @activity_id, @user_code, GETDATE(), 0, GETDATE(), @user_code, GETDATE(), @user_code, 'Y')
			END
		END
	END
	ELSE
	BEGIN
		--Hard
		--Nothing to do

		--Soft
		--Set to Hard
		UPDATE cstd_phone_dnc_wireless SET dnc_flag = 'Y', dnc_date = GETDATE(), dnc_flag_user_code = @user_code
			WHERE phonenumber = @phone_number AND ISNULL(dnc_flag,'N') = 'N' AND ebr_dnc_flag = 'Y'
	END
END
GO
