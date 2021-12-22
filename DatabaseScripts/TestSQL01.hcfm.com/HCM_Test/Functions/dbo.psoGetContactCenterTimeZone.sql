/* CreateDate: 01/03/2013 10:22:39.223 , ModifyDate: 01/03/2013 10:22:39.223 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[psoGetContactCenterTimeZone]
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @TimeZoneCode NCHAR(10)
	SET @TimeZoneCode = (	SELECT TOP 1
							oncd_company_address.time_zone_code
							FROM oncd_activity
							INNER JOIN oncd_activity_contact ON
								oncd_activity_contact.contact_id = @ContactId AND
								oncd_activity.activity_id = oncd_activity_contact.activity_id AND
								oncd_activity_contact.primary_flag = 'Y'
							INNER JOIN oncd_activity_company ON
								oncd_activity.activity_id = oncd_activity_company.activity_id AND
								oncd_activity_company.primary_flag = 'Y'
							INNER JOIN oncd_company_address ON
								oncd_activity_company.company_id = oncd_company_address.company_id
							WHERE
							oncd_activity.action_code = 'APPOINT' AND
							oncd_activity.result_code IS NULL)

	IF @TimeZoneCode IS NULL
	BEGIN
		SET @TimeZoneCode = (	SELECT TOP 1
								oncd_company_address.time_zone_code
								FROM oncd_contact_company
								INNER JOIN oncd_company_address ON
									oncd_contact_company.company_id = oncd_company_address.company_id
								WHERE oncd_contact_company.contact_id = @ContactId
								ORDER BY oncd_contact_company.primary_flag DESC, oncd_contact_company.sort_order, oncd_company_address.primary_flag DESC, oncd_company_address.sort_order)
	END

	RETURN @TimeZoneCode
END
GO
