/* CreateDate: 10/26/2011 09:43:05.467 , ModifyDate: 04/27/2012 09:50:38.700 */
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 4/23/08
-- Description:	Close actvities based on existing activities and passed in values
--
-- Updated:		1/5/09
-- By:			Oncontact PSO Fred Remers
-- Description:	Added logic for recovery activity - disposition outcalls
--
-- Updated:		10/9/09
-- By:			Oncontact PSO Fred Remers
-- Description	Added SHNOBUYCAL to close list list for the following:
--				IF(@action_code = 'BEBACK' and @result_code IN ('SHOWSALE','SHOWNOSALE'))
--				IF(@result_code = 'APPOINT' or @result_code = 'RESCHEDULE')
--
-- Update Date: 27 June 2011
-- Description: Do not disposition Confirmations as Cancel when the result is Brochure.
--
-- Update Date: 11 July 2011
-- Description: Removed logic to cancel Brochure Calls.
--
-- Update Date: 21 September 2011
-- Item #	  : 10
-- Description: Do not cancel Appointment Activities if No Confirmation Call (oncd_activity.cst_no_followup_flag)
--				is set to 'Y'.  Previously cancelling the Confirmation Call would also cancel the Appointment.
--
-- Update Date: 29 September 2011
-- Item #     : 10
-- Description: 1. Changed formatting to improve readability.
--				2. Removed commented out business rules.
--
-- Update Date: 7 October 2011
-- Item #	  : 42
-- Description: Automatically close the Outbound Brochure Call if the Contact has an open Appointment.
-- =============================================
CREATE PROCEDURE [dbo].[pso_DispositionActivities] (
	@activity_id nchar(10),
	@action_code nchar(10),
	@result_code nchar(10),
	@contact_id nchar(10)
)
AS

BEGIN
	SET NOCOUNT ON;
	-- Check to make sure that the trigger user exists in onca_user and add it if the user does not
	IF (SELECT user_code FROM onca_user WHERE user_code = 'TRIGGER') IS NULL
		INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('TRIGGER', 'Trigger', 'Trigger', 'N')

	DECLARE @has_open_appointment	NCHAR(1)
	DECLARE @is_marketing_activity	NCHAR(1)
	DECLARE @do_not_call			NCHAR(1)
	DECLARE @do_not_solicit			NCHAR(1)
	DECLARE @out_call_activity		NCHAR(1)

	DECLARE @debug NCHAR(1)
	SET @debug = 'N'

	DECLARE @NoFollowUpSelected NCHAR(1)
	SET @NoFollowUpSelected = ISNULL((SELECT cst_no_followup_flag FROM oncd_activity WHERE activity_id = @activity_id),'N')

	SELECT
		@do_not_call = ISNULL(cst_do_not_call, 'N'),
		@do_not_solicit = ISNULL(do_not_solicit, 'N')
	FROM oncd_contact
	WHERE
		contact_id = @contact_id

	SET @out_call_activity = ISNULL((SELECT cst_noble_addition FROM onca_action WHERE action_code = @action_code), 'N')

	IF (@out_call_activity = 'Y' AND
	   (@do_not_call = 'Y' OR @do_not_solicit = 'Y'))
	BEGIN
		UPDATE oncd_activity
		SET
			result_code = 'CANCEL'
		WHERE
			activity_id = @activity_id AND
			result_code IS NULL
	END

	IF (@action_code = 'CONFIRM' AND
		@result_code = 'CANCEL' AND
		@NoFollowUpSelected = 'N')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 1: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code = 'APPOINT' AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@action_code = 'CONFIRM' AND
		@result_code IS NOT NULL AND
		@result_code NOT IN ('RESCHEDULE', 'BROCHURE'))
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 2: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), null),
			completion_time = dbo.CombineDates(null, GETDATE())
		WHERE
			action_code = 'CONFIRM' AND
			result_code IS NULL AND
			activity_id <> @activity_id AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@action_code = 'APPOINT' AND
		@result_code IN ('SHOWSALE','NOSHOW','SHOWNOSALE'))
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 3: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code = 'CONFIRM' AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@action_code = 'APPOINT' AND
		@result_code = 'RESCHEDULE')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 4: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'RESCHEDULE',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code = 'CONFIRM' AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@result_code IN ('APPOINT', 'RESCHEDULE'))
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 5: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), null),
			completion_time = dbo.CombineDates(null, GETDATE())
		WHERE
			action_code IN ('NOSHOWCALL', 'CANCELCALL', 'OUTSELECT', 'SHNOBUYCAL') AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@action_code = 'BEBACK' AND
		@result_code IN ('SHOWSALE','SHOWNOSALE'))
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 6: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code IN ('NOSHOWCALL','CANCELCALL','OUTSELECT','SHNOBUYCAL') AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@action_code = 'INCALL' AND
		@result_code = 'DRCTCNFIRM')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 7: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code = 'CONFIRM' AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id )
	END

	IF (@action_code = 'RECOVERY')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 8: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code IN ('NOSHOWCALL', 'CANCELCALL', 'OUTSELECT') AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	IF (@action_code = 'BROCHCALL')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities','IF (@action_code = ''BROCHCALL'')' + @activity_id)
		END

		IF EXISTS ( SELECT 1
					FROM oncd_activity
					INNER JOIN oncd_activity_contact ON
						oncd_activity.activity_id = oncd_activity_contact.activity_id
					WHERE
						oncd_activity.action_code = 'APPOINT' AND
						oncd_activity.result_code IS NULL AND
						oncd_activity_contact.contact_id = @contact_id)
		BEGIN
			UPDATE oncd_activity
			SET
				result_code = 'CANCEL'
			WHERE
				result_code IS NULL AND
				activity_id = @activity_id
		END
	END

	IF (SELECT
			COUNT(*)
		FROM oncd_activity
		INNER JOIN oncd_activity_contact ON
			oncd_activity_contact.contact_id = @contact_id AND
			oncd_activity.activity_id = oncd_activity_contact.activity_id AND
			oncd_activity_contact.primary_flag = 'Y'
		WHERE
			oncd_activity.action_code = 'APPOINT' AND
			oncd_activity.activity_id <> @activity_id AND
			oncd_activity.result_code IS NULL) > 0
	BEGIN
		SET @has_open_appointment = 'Y'
	END
	ELSE
	BEGIN
		SET @has_open_appointment = 'N'
	END

	IF (@has_open_appointment = 'Y')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities','IF (@has_open_appointment = ''Y'')' + @activity_id)
		END

		DECLARE @confirmation_activity_id NCHAR(10)
		SET @confirmation_activity_id = (	SELECT TOP 1
												activity_id
											FROM oncd_activity
											WHERE
												action_code = 'CONFIRM' AND
												result_code IS NULL AND
												activity_id IN (SELECT
																	activity_id
																FROM oncd_activity_contact
																WHERE
																	contact_id = @contact_id)
											ORDER BY
												creation_date DESC)

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			--description = 'TESTING',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code NOT IN ('APPOINT') AND
			activity_id <> ISNULL(@confirmation_activity_id, '') AND
			action_code IN (SELECT
								action_code
							FROM onca_action
							WHERE
								cst_noble_exclusion = 'Y') AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END
	ELSE
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities','IF (@has_open_appointment = ''N'')' + @activity_id)
		END

		DECLARE @most_recent_activity_id NCHAR(10)
		SET @most_recent_activity_id = (SELECT TOP 1
											oncd_activity.activity_id
										FROM oncd_activity
										INNER JOIN onca_action ON
											oncd_activity.action_code = onca_action.action_code
										INNER JOIN oncd_activity_contact ON
											oncd_activity.activity_id = oncd_activity_contact.activity_id
										WHERE
											oncd_activity.result_code IS NULL AND
											onca_action.cst_noble_exclusion = 'Y' AND
											oncd_activity_contact.contact_id = @contact_id
										ORDER BY
											oncd_activity.creation_date DESC)

		IF (@most_recent_activity_id IS NOT NULL)
		BEGIN
			UPDATE oncd_activity
			SET
				result_code = 'CANCEL',
				updated_date = GETDATE(),
				updated_by_user_code = 'TRIGGER',
				completed_by_user_code = 'TRIGGER',
				completion_date = dbo.CombineDates(GETDATE(), NULL),
				completion_time = dbo.CombineDates(NULL, GETDATE())
			WHERE
				activity_id <> @most_recent_activity_id AND
				action_code NOT IN ('APPOINT', 'CONFIRM') AND
				action_code IN (SELECT
									action_code
								FROM onca_action
								WHERE
									cst_noble_exclusion = 'Y') AND
				result_code IS NULL AND
				activity_id IN (SELECT
									activity_id
								FROM oncd_activity_contact
								WHERE
									contact_id = @contact_id)
		END
	END

	IF (@action_code IN ('BROCHCALL', 'CANCELCALL', 'NOSHOWCALL', 'OUTSELECT'))
	BEGIN
		SET @is_marketing_activity = 'Y'
	END
	ELSE
	BEGIN
		SET @is_marketing_activity = 'N'
	END

	-- If this is a marketing activity and there is no open appointment, cancel all other marketing activities (exept this one)
	-- Contact should only have one open marketing activity at a time.
	IF (@is_marketing_activity = 'Y' AND
		@has_open_appointment = 'N')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities',' 9: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			result_code = 'CANCEL',
			updated_date = GETDATE(),
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code IN ('CANCELCALL', 'NOSHOWCALL', 'OUTSELECT') AND
			result_code IS NULL AND
			activity_id <> @activity_id AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END

	--If they already have an open appointment, make sure all other other marketing calls are canceled.
	IF (@has_open_appointment = 'Y')
	BEGIN
		IF (@debug = 'Y')
		BEGIN
			INSERT INTO cstd_sql_job_log (name, message)
				VALUES ('pso_DispositionActvities','10: ' + @activity_id)
		END

		UPDATE oncd_activity
		SET
			updated_by_user_code = 'TRIGGER',
			completed_by_user_code = 'TRIGGER',
			completion_date = dbo.CombineDates(GETDATE(), NULL),
			completion_time = dbo.CombineDates(NULL, GETDATE())
		WHERE
			action_code IN ('CANCELCALL', 'NOSHOWCALL', 'OUTSELECT') AND
			result_code IS NULL AND
			activity_id IN (SELECT
								activity_id
							FROM oncd_activity_contact
							WHERE
								contact_id = @contact_id)
	END
END
GO
