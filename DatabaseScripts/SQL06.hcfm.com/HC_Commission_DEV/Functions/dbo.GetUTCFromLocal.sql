/* CreateDate: 03/28/2017 12:53:04.063 , ModifyDate: 03/28/2017 12:53:04.063 */
GO
CREATE FUNCTION [dbo].[GetUTCFromLocal] ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @HoursToAdd INT = @UTCOffSet
	DECLARE @Year INT = DATEPART(YEAR, @MyDate)
	DECLARE @DSTStart DATETIME
	DECLARE @DSTEnd DATETIME


	SELECT	@DSTStart = DS.DSTStartDate
	,		@DSTEnd = DS.DSTEndDate
	FROM	SQL05.HairClubCMS.dbo.lkpDaylightSavings DS
	WHERE	DS.[Year] = @Year


	IF @UseDayLightSavings = 1 AND @MyDate >= @DSTStart AND @MyDate < @DSTEnd
	BEGIN
		SET @HoursToAdd = @HoursToAdd + 1
	END

	RETURN DATEADD(HOUR, @HoursToAdd * -1, @MyDate)
END
GO
