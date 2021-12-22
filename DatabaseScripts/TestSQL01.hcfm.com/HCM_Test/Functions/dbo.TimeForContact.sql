/* CreateDate: 12/01/2006 14:08:24.853 , ModifyDate: 05/01/2010 14:48:08.743 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].TimeForContact (
	@currentLocalTime datetime = NULL,
	@currentLocalTimeZoneOffSet float,
	@currentContactTimeZoneCode nchar(10)
					)

RETURNS dateTime AS
BEGIN
	/*Given the current (date)time in a particular timezone,
	function calculates the current datetime for the specified
	contact based on the timezone for the contacts primary address
	*/
	DECLARE @returnValue		datetime
	DECLARE @contactTZOffSet	float
	DECLARE @totalOffset		float

	IF @currentLocalTimeZoneOffSet is null OR
		@currentContactTimeZoneCode is null OR
		@currentLocalTime is NULL
		RETURN NULL

	SET @contactTZOffSet = (select greenwich_offset
					FROM onca_time_zone
					where time_zone_code = @currentContactTimeZoneCode )

	if @contactTZOffSet is null
		RETURN NULL

	SET @totalOffset = -1 * @currentLocalTimeZoneOffSet + @contactTZOffset
	SET @returnValue = DATEADD(hour,@totalOffset,@currentLocalTime)

	RETURN @returnValue
END
GO
