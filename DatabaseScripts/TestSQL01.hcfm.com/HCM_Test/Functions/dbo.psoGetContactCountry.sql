/* CreateDate: 01/03/2013 10:22:38.780 , ModifyDate: 01/03/2013 10:22:38.780 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[psoGetContactCountry]
(
	@ContactId NCHAR(10)
)
RETURNS NCHAR(10)
AS
BEGIN
	DECLARE @CountryCode NCHAR(10)

	SELECT TOP 1
	@CountryCode = country_code
	FROM (
	SELECT oncd_contact_address.country_code
	FROM oncd_contact_address
	WHERE contact_id = @ContactId
	UNION ALL
	SELECT onca_zip.country_code
	FROM oncd_contact_address
	INNER JOIN onca_zip ON oncd_contact_address.zip_code = onca_zip.zip_code
	WHERE contact_id = @ContactId
	) AS results
	ORDER BY country_code DESC

	RETURN @CountryCode

END
GO
