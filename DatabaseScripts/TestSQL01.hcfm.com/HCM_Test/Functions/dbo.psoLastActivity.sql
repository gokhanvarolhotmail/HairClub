/* CreateDate: 10/15/2013 04:44:49.933 , ModifyDate: 10/15/2013 04:44:49.933 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoLastActivity]
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
oncd_activity_contact.contact_id = @ContactId
ORDER BY oncd_activity.completion_date desc, oncd_activity.completion_time desc)

END
GO
