/* CreateDate: 10/15/2013 00:55:12.110 , ModifyDate: 10/15/2013 00:55:12.110 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[psoCurrentSource]
(
	@ContactId	NCHAR(10)
)
RETURNS NCHAR(50)
AS
BEGIN

RETURN (
SELECT TOP 1 onca_source.description
FROM oncd_activity WITH (NOLOCK)
INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity.activity_id = oncd_activity_contact.activity_id
INNER JOIN onca_source WITH (NOLOCK) ON oncd_activity.source_code = onca_source.source_code
WHERE
oncd_activity_contact.contact_id = @ContactId
ORDER BY oncd_activity.due_date desc, oncd_activity.start_time desc)

END
GO
