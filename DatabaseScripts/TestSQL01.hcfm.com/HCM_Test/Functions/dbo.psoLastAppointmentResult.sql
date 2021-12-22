/* CreateDate: 10/15/2013 00:55:26.047 , ModifyDate: 10/15/2013 00:55:26.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoLastAppointmentResult]
(
	@ContactId	NCHAR(10)
)
RETURNS NCHAR(50)
AS
BEGIN

RETURN (
SELECT TOP 1 onca_result.description
FROM oncd_activity WITH (NOLOCK)
INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
INNER JOIN onca_result WITH (NOLOCK) ON oncd_activity.result_code = onca_result.result_code
WHERE
oncd_activity.action_code = 'APPOINT' AND
oncd_activity.result_code IS NOT NULL AND
oncd_activity_contact.contact_id = @ContactId
ORDER BY oncd_activity.completion_date desc, oncd_activity.completion_time desc)

END
GO
