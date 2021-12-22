/* CreateDate: 10/15/2013 02:33:10.117 , ModifyDate: 10/15/2013 02:33:24.460 */
GO
CREATE FUNCTION [dbo].[psoNextAppointmentId]
(
	@ContactId	NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN

RETURN (
SELECT TOP 1 oncd_activity.activity_id
FROM oncd_activity WITH (NOLOCK)
INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
WHERE
oncd_activity.action_code = 'APPOINT' AND
oncd_activity.result_code IS NULL AND
oncd_activity_contact.contact_id = @ContactId
ORDER BY oncd_activity.due_date desc, oncd_activity.start_time desc)

END
GO
