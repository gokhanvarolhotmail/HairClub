/* CreateDate: 06/20/2012 11:34:07.353 , ModifyDate: 06/20/2012 11:34:07.353 */
GO
-- =============================================
-- Create date: 18 June 2012
-- Description:	Populates and updates cstd_email_dh_brochure_activity
-- =============================================
CREATE PROCEDURE [dbo].[pso_UpdateContactCompletionActivities]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE cstd_email_dh_contact_completion

	INSERT INTO cstd_email_dh_contact_completion ( contact_completion_id, contact_id, creation_date)
	SELECT contact_completion_id, contact_id, creation_date
	FROM cstd_contact_completion

	DELETE FROM cstd_email_dh_contact_completion
	WHERE contact_completion_id IN (
	SELECT b.contact_completion_id
	FROM cstd_email_dh_contact_completion a, cstd_email_dh_contact_completion b
	WHERE
	a.contact_id = b.contact_id AND
	a.contact_completion_id <> b.contact_completion_id AND
	a.creation_date > b.creation_date)

	DELETE FROM cstd_email_dh_contact_completion
	WHERE contact_completion_id IN (
	SELECT a.contact_completion_id
	FROM cstd_email_dh_contact_completion a, cstd_email_dh_contact_completion b
	WHERE
	a.contact_id = b.contact_id AND
	a.contact_completion_id > b.contact_completion_id)

END
GO
