/* CreateDate: 03/28/2017 12:52:41.653 , ModifyDate: 03/28/2017 12:52:41.653 */
GO
CREATE FUNCTION [dbo].[GetLocalFromUTC] ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @Local DATETIME = DATEADD(HOUR, @UTCOffSet, @MyDate)
	DECLARE @Year INT = DATEPART(YEAR, @MyDate)
	DECLARE @DSTStart DATETIME
	DECLARE @DSTEnd DATETIME


	SELECT	@DSTStart = DS.DSTStartDate
	,		@DSTEnd = DS.DSTEndDate
	FROM	SQL05.HairClubCMS.dbo.lkpDaylightSavings DS
	WHERE	DS.[Year] = @Year


	IF @UseDayLightSavings = 1 AND @Local >= @DSTStart AND @Local < @DSTEnd
	BEGIN
		SET @Local = DATEADD(HOUR, 1, @Local)
	END

	RETURN @Local
END
GO
