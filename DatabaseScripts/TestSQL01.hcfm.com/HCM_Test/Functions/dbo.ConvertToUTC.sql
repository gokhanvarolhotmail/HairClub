/* CreateDate: 08/30/2011 11:12:50.353 , ModifyDate: 12/15/2016 09:51:40.963 */
GO
-- =============================================
-- Create date: 24 August 2011
-- Description:	Uses the provided time zone code to convert the provided date to UTC.
-- Modified: 2016-10-19 MJW	allow for null Offset
-- =============================================
CREATE FUNCTION [dbo].[ConvertToUTC]
(
	@DateTime DATETIME, @TimeZoneCode NCHAR(10)
)
RETURNS DATETIME
AS
BEGIN
	DECLARE @Offset INT
	DECLARE @returnValue DATETIME

	SET @Offset = (SELECT greenwich_offset FROM onca_time_zone WHERE time_zone_code = @TimeZoneCode)

	IF @Offset IS NOT NULL
	BEGIN
		IF EXISTS ( SELECT 1 FROM csta_daylight_savings WHERE @DateTime BETWEEN start_date AND end_date)
		BEGIN
			SET @Offset = @Offset + 1
		END

		SET @returnValue = DATEADD(HOUR, -@Offset, @DateTime)
	END
	ELSE
		SET @returnValue = NULL

	RETURN @returnValue
END
GO
