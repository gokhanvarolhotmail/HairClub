/* CreateDate: 10/15/2013 00:09:17.307 , ModifyDate: 10/15/2013 00:09:17.307 */
GO
CREATE FUNCTION dbo.psoActivityLanguage
(
	@ActivityId	NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @LanguageCode NCHAR(10)

	SET @LanguageCode = (SELECT TOP 1
						 oncd_contact.cst_language_code
						 FROM oncd_activity
						 INNER JOIN oncd_activity_contact ON oncd_activity.activity_id = oncd_activity_contact.activity_id
						 INNER JOIN oncd_contact ON oncd_activity_contact.contact_id = oncd_contact.contact_id
						 WHERE oncd_activity.activity_id = @ActivityId)

	RETURN @LanguageCode
END
GO
