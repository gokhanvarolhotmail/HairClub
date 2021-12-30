/* CreateDate: 11/09/2016 11:53:08.427 , ModifyDate: 11/09/2016 12:26:07.307 */
GO
CREATE FUNCTION [bief_stage].GetLocalFromUTC ( @MyDate DATETIME, @UTCOffSet INT, @UseDayLightSavings BIT )
RETURNS DATETIME
AS
BEGIN
	DECLARE @Local DATETIME = DATEADD(HOUR, @UTCOffSet, @MyDate)

	IF @UseDayLightSavings = 1 AND @Local >= [bief_stage].GetDSTStart(DATEPART(YEAR, @Local)) AND @Local < [bief_stage].GetDSTEnd(DATEPART(YEAR, @Local))
	BEGIN
		SET @Local = DATEADD(HOUR, 1, @Local)
	END

	RETURN @Local
END
GO
