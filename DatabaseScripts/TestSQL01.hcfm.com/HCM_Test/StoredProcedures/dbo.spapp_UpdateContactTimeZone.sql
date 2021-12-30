/* CreateDate: 08/15/2007 10:23:19.683 , ModifyDate: 05/01/2010 14:48:10.673 */
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 	8/09/07
-- Description:		Update timezones for contacts where tz is null
-- Modified:		11/28/2007 (Russ Kahler)

-- Modified:		12/04/2008 (Fred Remers)
--					Removed primary flag from cursor sql so all addresses get updated
-- =============================================
CREATE PROCEDURE [dbo].[spapp_UpdateContactTimeZone]
AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @contact_id nchar(10)
	DECLARE @contact_address_id nchar(10)
	DECLARE @time_zone_code nchar(10)

	DECLARE cursor_no_timezone CURSOR FOR
		SELECT oncd_contact.contact_id, oncd_contact_address.contact_address_id
		FROM oncd_contact
		INNER JOIN oncd_contact_address on oncd_contact_address.contact_id = oncd_contact.contact_id and (oncd_contact_address.time_zone_code is null or oncd_contact_address.time_zone_code = '')

	OPEN cursor_no_timezone
	FETCH NEXT FROM cursor_no_timezone INTO @contact_id, @contact_address_id
	WHILE ( @@fetch_status = 0)
	BEGIN
		SET @time_zone_code = (select top 1 onca_county.time_zone_code from onca_county
			inner join onca_zip on onca_zip.county_code = onca_county.county_code
			inner join oncd_contact_address on oncd_contact_address.zip_code = onca_zip.zip_code
			and oncd_contact_address.contact_id = @contact_id)

		IF (ISNULL(@time_zone_code, ' ') = ' ')
			SET @time_zone_code = (select top 1 ca.time_zone_code
									from oncd_contact_company cc
										inner join oncd_company_address ca on ca.company_id = cc.company_id
									where 	cc.contact_id = @contact_id
										and cc.primary_flag = 'Y')

		IF (ISNULL(@time_zone_code, ' ') = ' ')
			SET @time_zone_code = 'EST'

		UPDATE oncd_contact_address set time_zone_code = @time_zone_code where contact_address_id = @contact_address_id

		FETCH NEXT FROM cursor_no_timezone INTO @contact_id, @contact_address_id
	END

	CLOSE cursor_no_timezone
	DEALLOCATE cursor_no_timezone
END
GO
