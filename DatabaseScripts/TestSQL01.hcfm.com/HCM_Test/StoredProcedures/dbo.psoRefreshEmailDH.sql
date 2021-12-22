/* CreateDate: 06/20/2012 11:33:05.277 , ModifyDate: 07/23/2014 18:25:23.847 */
GO
-- =============================================
-- Create date: 18 June 2012
-- Description:	Performs full population of cstd_email_dh_flat with data.
-- =============================================
CREATE PROCEDURE [dbo].[psoRefreshEmailDH]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Text		NVARCHAR(1000)
	DECLARE @ContactDate	DATETIME
	DECLARE @ActivityDate	DATETIME

	SET @ContactDate = dbo.CombineDates(DATEADD(YEAR, -7, GETDATE()), NULL)
	SET @ActivityDate = dbo.CombineDates(DATEADD(MONTH, -24, GETDATE()), NULL)

	TRUNCATE TABLE cstd_email_dh_flat

	SET @Text = 'Building Activity Demographics: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	EXEC pso_UpdateActivityDemographicActivities

	SET @Text = 'Building Contact Completions: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	EXEC pso_UpdateContactCompletionActivities

	SET @Text = 'Building Appointment Activities: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	EXEC pso_UpdateEmailAppointmentActivities

	SET @Text = 'Building Brochure Activities: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	EXEC pso_UpdateEmailBrochureActivities

	SET @Text = 'Building Contact List: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	INSERT INTO cstd_email_dh_flat ( contact_contact_id )
		SELECT DISTINCT
			oncd_contact.contact_id AS contact_contact_id
		FROM oncd_contact WITH (NOLOCK)
		INNER JOIN oncd_contact_email WITH (NOLOCK) ON
			oncd_contact.contact_id = oncd_contact_email.contact_id AND
			oncd_contact_email.primary_flag = 'Y' AND
			LEN(RTRIM(ISNULL(oncd_contact_email.email,''))) > 0
		INNER JOIN oncd_activity_contact WITH (NOLOCK) ON
			oncd_contact.contact_id = oncd_activity_contact.contact_id
		INNER JOIN oncd_activity WITH (NOLOCK) ON
			oncd_activity_contact.activity_id = oncd_activity.activity_id
		WHERE
			oncd_contact.contact_status_code = 'LEAD' AND
			oncd_contact.creation_date >= @ContactDate AND
			--oncd_activity.result_code = 'BROCHURE' AND
			oncd_activity.action_code IN ( 'APPOINT', 'BROCHCALL' ) AND
			oncd_activity.creation_date >= @ActivityDate

	SET @Text = 'Cleaning Activity Demographics: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	DELETE FROM cstd_email_dh_activity_demographic
		FROM cstd_email_dh_activity_demographic data
		LEFT OUTER JOIN cstd_email_dh_flat flat ON data.contact_id = flat.contact_contact_id
		WHERE flat.contact_contact_id IS NULL

	SET @Text = 'Cleaning Appointment Activities: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	DELETE FROM cstd_email_dh_appointment_activity
		FROM cstd_email_dh_appointment_activity data
		LEFT OUTER JOIN cstd_email_dh_flat flat ON data.contact_id = flat.contact_contact_id
		WHERE flat.contact_contact_id IS NULL

	SET @Text = 'Cleaning Brochure Activities: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	DELETE FROM cstd_email_dh_brochure_activity
		FROM cstd_email_dh_brochure_activity data
		LEFT OUTER JOIN cstd_email_dh_flat flat ON data.contact_id = flat.contact_contact_id
		WHERE flat.contact_contact_id IS NULL

	SET @Text = 'Cleaning Contact Completion: ' + CONVERT(NVARCHAR(50), GETDATE(), 108)
	RAISERROR(@Text, 0, 1) WITH NOWAIT
	DELETE FROM cstd_email_dh_contact_completion
		FROM cstd_email_dh_contact_completion data
		LEFT OUTER JOIN cstd_email_dh_flat flat ON data.contact_id = flat.contact_contact_id
		WHERE flat.contact_contact_id IS NULL

	EXEC pso_RefreshEmailDHContactBatch

END
GO
