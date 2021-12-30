/* CreateDate: 01/03/2013 10:22:38.797 , ModifyDate: 01/03/2013 10:22:38.797 */
GO
-- =============================================
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION dbo.psoGetActivityPrimaryContact
(
@ActivityId NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @ContactId NCHAR(10)

	SELECT TOP 1
	@ContactId = contact_id
	FROM oncd_activity_contact
	WHERE
	activity_id = @ActivityId AND
	primary_flag = 'Y'

	RETURN @ContactId
END
GO
