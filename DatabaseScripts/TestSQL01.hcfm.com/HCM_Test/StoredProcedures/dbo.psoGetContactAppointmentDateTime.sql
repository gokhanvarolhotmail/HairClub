/* CreateDate: 01/03/2013 10:22:39.233 , ModifyDate: 01/03/2013 10:22:39.233 */
GO
-- =============================================
-- Create date: 30 October 2012
-- Description:	Provides the Due Date and Start Time of the provided Contact's Appointment Activity.
-- =============================================
CREATE PROCEDURE [dbo].[psoGetContactAppointmentDateTime]
	@ContactId	NCHAR(10),		-- The Contact to get the Appointment Activity for.
	@DueDate	DATETIME OUTPUT,-- The Due Date of the Appointment Activity.
	@StartTime	DATETIME OUTPUT	-- The Start Time of the Appointment Activity.
AS
BEGIN
	SELECT TOP 1
	@DueDate = oncd_activity.due_date,
	@StartTime = oncd_activity.start_time
	FROM oncd_activity
	INNER JOIN oncd_activity_contact ON
		oncd_activity_contact.contact_id = @ContactId AND
		oncd_activity.activity_id = oncd_activity_contact.activity_id AND
		oncd_activity_contact.primary_flag = 'Y'
	WHERE
	oncd_activity.action_code = 'APPOINT'
	ORDER BY oncd_activity.result_code, due_date DESC, start_time DESC
END
GO
