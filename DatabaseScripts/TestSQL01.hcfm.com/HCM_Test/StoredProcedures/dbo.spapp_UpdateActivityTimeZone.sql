/* CreateDate: 07/05/2007 11:59:59.560 , ModifyDate: 05/01/2010 14:48:10.733 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:			Oncontact PSO Fred Remers
-- Create date: 	6/28/07
-- Description:		Update timezones on open activities where tz is null
-- Modified:		11/29/2007 (Russ Kahler)
-- =============================================
CREATE PROCEDURE [dbo].[spapp_UpdateActivityTimeZone]
AS

BEGIN
	SET NOCOUNT ON;
	DECLARE @activity_id nchar(10)
	DECLARE @contact_id nchar(10)
	DECLARE @time_zone_code nchar(10)

	DECLARE cursor_no_tz CURSOR FOR
		SELECT oncd_activity.activity_id, oncd_activity_contact.contact_id
		FROM oncd_activity
		INNER JOIN oncd_activity_contact on oncd_activity_contact.activity_id = oncd_activity.activity_id and oncd_activity_contact.primary_flag = 'y'
		WHERE (oncd_activity.cst_time_zone_code is null or oncd_activity.cst_time_zone_code = '')
		and (oncd_activity.result_code is null or oncd_activity.result_code = '')

	OPEN cursor_no_tz
	FETCH NEXT FROM cursor_no_tz INTO @activity_id, @contact_id
	WHILE ( @@fetch_status = 0)
	BEGIN
		SET @time_zone_code = (select top 1 ca.time_zone_code
					from oncd_contact_address ca
					where ca.contact_id = @contact_id)

		IF (ISNULL(@time_zone_code, ' ') <> ' ')
			UPDATE oncd_activity set cst_time_zone_code = @time_zone_code where activity_id = @activity_id

		FETCH NEXT FROM cursor_no_tz INTO @activity_id, @contact_id
	END

	CLOSE cursor_no_tz
	DEALLOCATE cursor_no_tz
END
GO
