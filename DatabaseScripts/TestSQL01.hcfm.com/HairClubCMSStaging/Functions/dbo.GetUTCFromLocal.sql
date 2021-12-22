/* CreateDate: 11/09/2016 12:17:40.970 , ModifyDate: 11/18/2016 15:35:35.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION GetUTCFromLocal ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @HoursToAdd INT = @UTCOffSet
	DECLARE @Year INT = DATEPART(YEAR, @MyDate)
	DECLARE @DSTStart DATETIME
	DECLARE @DSTEnd DATETIME


	SELECT	@DSTStart = DS.DSTStartDate
	,		@DSTEnd = DS.DSTEndDate
	FROM	lkpDaylightSavings DS
	WHERE	DS.[Year] = @Year


	IF @UseDayLightSavings = 1 AND @MyDate >= @DSTStart AND @MyDate < @DSTEnd
	BEGIN
		SET @HoursToAdd = @HoursToAdd + 1
	END

	RETURN DATEADD(HOUR, @HoursToAdd * -1, @MyDate)
END
GO
