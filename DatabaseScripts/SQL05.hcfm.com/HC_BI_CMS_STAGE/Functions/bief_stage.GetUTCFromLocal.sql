/* CreateDate: 11/09/2016 11:53:08.270 , ModifyDate: 11/09/2016 12:26:07.167 */
GO
CREATE FUNCTION [bief_stage].GetUTCFromLocal ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @HoursToAdd INT = @UTCOffSet

	IF @UseDayLightSavings = 1 AND @MyDate >= [bief_stage].GetDSTStart(DATEPART(YEAR, @MyDate)) AND @MyDate < [bief_stage].GetDSTEnd(DATEPART(YEAR, @MyDate))
	BEGIN
		SET @HoursToAdd = @HoursToAdd + 1
	END

	RETURN DATEADD(HOUR, @HoursToAdd * -1, @MyDate)
END
GO
