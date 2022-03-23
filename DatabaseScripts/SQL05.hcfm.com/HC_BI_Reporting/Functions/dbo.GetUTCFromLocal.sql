/* CreateDate: 11/09/2016 12:00:52.680 , ModifyDate: 11/09/2016 12:00:52.680 */
GO
CREATE FUNCTION GetUTCFromLocal ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @HoursToAdd INT = @UTCOffSet

	IF @UseDayLightSavings = 1 AND @MyDate >= dbo.GetDSTStart(DATEPART(YEAR, @MyDate)) AND @MyDate < dbo.GetDSTEnd(DATEPART(YEAR, @MyDate))
	BEGIN
		SET @HoursToAdd = @HoursToAdd + 1
	END

	RETURN DATEADD(HOUR, @HoursToAdd * -1, @MyDate)
END
GO
