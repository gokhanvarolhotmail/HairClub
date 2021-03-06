/* CreateDate: 11/09/2016 12:17:40.987 , ModifyDate: 11/18/2016 15:37:08.147 */
GO
CREATE FUNCTION GetLocalFromUTC ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @Local DATETIME = DATEADD(HOUR, @UTCOffSet, @MyDate)
	DECLARE @Year INT = DATEPART(YEAR, @MyDate)
	DECLARE @DSTStart DATETIME
	DECLARE @DSTEnd DATETIME


	SELECT	@DSTStart = DS.DSTStartDate
	,		@DSTEnd = DS.DSTEndDate
	FROM	lkpDaylightSavings DS
	WHERE	DS.[Year] = @Year


	IF @UseDayLightSavings = 1 AND @Local >= @DSTStart AND @Local < @DSTEnd
	BEGIN
		SET @Local = DATEADD(HOUR, 1, @Local)
	END

	RETURN @Local
END
GO
