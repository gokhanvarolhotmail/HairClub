/* CreateDate: 10/15/2013 00:19:18.967 , ModifyDate: 10/15/2013 00:19:18.967 */
GO
CREATE FUNCTION [dbo].[psoHasOpenConfirmationCall]
(
	@ContactId	NCHAR(10)
)
RETURNS NCHAR(1)
AS
BEGIN

RETURN ISNULL((
SELECT TOP 1 'Y'
FROM oncd_activity
INNER JOIN oncd_activity_contact ON oncd_activity.activity_id = oncd_activity_contact.activity_id
WHERE
oncd_activity.action_code = 'CONFIRM' AND
oncd_activity.result_code IS NULL AND
oncd_activity_contact.contact_id = @ContactId),'N')

END
GO
