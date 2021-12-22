/* CreateDate: 06/20/2012 11:33:27.750 , ModifyDate: 06/20/2012 11:33:48.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 18 June 2012
-- Description:	Populates and updates cstd_email_dh_appointment_activity
-- =============================================
CREATE PROCEDURE [dbo].[pso_UpdateEmailAppointmentActivities]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE cstd_email_dh_appointment_activity

	INSERT INTO cstd_email_dh_appointment_activity ( activity_id, contact_id, due_date)
	SELECT oncd_activity.activity_id, oncd_activity_contact.contact_id, oncd_activity.due_date
	FROM oncd_activity
	INNER JOIN oncd_activity_contact ON oncd_activity.activity_id = oncd_activity_contact.activity_id
	WHERE oncd_activity.action_code = 'APPOINT'

	DELETE FROM cstd_email_dh_appointment_activity
	WHERE activity_id IN (
	SELECT b.activity_id
	FROM cstd_email_dh_appointment_activity a, cstd_email_dh_appointment_activity b
	WHERE
	a.contact_id = b.contact_id AND
	a.activity_id <> b.activity_id AND
	((a.due_date > b.due_date) OR
	 (a.due_date = b.due_date AND a.start_time > b.start_time))
	)

	DELETE FROM cstd_email_dh_appointment_activity
	WHERE activity_id IN (
	SELECT a.activity_id
	FROM cstd_email_dh_appointment_activity a, cstd_email_dh_appointment_activity b
	WHERE
	a.contact_id = b.contact_id AND
	a.activity_id > b.activity_id)

END
GO
