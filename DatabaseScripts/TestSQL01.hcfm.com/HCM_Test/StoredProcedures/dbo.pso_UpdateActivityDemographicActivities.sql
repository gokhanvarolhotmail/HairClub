/* CreateDate: 06/20/2012 11:34:07.440 , ModifyDate: 06/20/2012 11:34:07.440 */
GO
-- =============================================
-- Create date: 18 June 2012
-- Description:	Populates and updates cstd_email_dh_brochure_activity
-- =============================================
CREATE PROCEDURE [dbo].[pso_UpdateActivityDemographicActivities]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE cstd_email_dh_activity_demographic

	INSERT INTO cstd_email_dh_activity_demographic ( activity_demographic_id, contact_id, updated_date)
	SELECT cstd_activity_demographic.activity_demographic_id, oncd_activity_contact.contact_id, cstd_activity_demographic.updated_date
	FROM cstd_activity_demographic
	INNER JOIN oncd_activity WITH (NOLOCK) ON
		cstd_activity_demographic.activity_id = oncd_activity.activity_id
	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON
		oncd_activity.activity_id = oncd_activity_contact.activity_id

	DELETE FROM cstd_email_dh_activity_demographic
	WHERE activity_demographic_id IN (
	SELECT b.activity_demographic_id
	FROM cstd_email_dh_activity_demographic a, cstd_email_dh_activity_demographic b
	WHERE
	a.contact_id = b.contact_id AND
	a.activity_demographic_id <> b.activity_demographic_id AND
	a.updated_date > b.updated_date)

	DELETE FROM cstd_email_dh_activity_demographic
	WHERE activity_demographic_id IN (
	SELECT a.activity_demographic_id
	FROM cstd_email_dh_activity_demographic a, cstd_email_dh_activity_demographic b
	WHERE
	a.contact_id = b.contact_id AND
	a.activity_demographic_id > b.activity_demographic_id)

END
GO
