/* CreateDate: 10/15/2013 00:55:36.160 , ModifyDate: 10/18/2013 14:43:15.537 */
GO
CREATE FUNCTION [dbo].[psoLastAppointmentDate]
(
	@ContactId	NCHAR(10)
)
RETURNS DATETIME
AS
BEGIN

RETURN (
SELECT TOP 1 CONVERT(varchar(10),oncd_activity.due_date,101)
FROM oncd_activity WITH (NOLOCK)
INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
WHERE
oncd_activity.action_code = 'APPOINT' AND
oncd_activity.result_code IS NOT NULL AND
oncd_activity_contact.contact_id = @ContactId
ORDER BY oncd_activity.completion_date desc, oncd_activity.completion_time desc)

END
GO
