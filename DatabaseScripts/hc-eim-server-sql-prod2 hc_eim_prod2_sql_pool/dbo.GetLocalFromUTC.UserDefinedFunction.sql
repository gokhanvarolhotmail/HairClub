/****** Object:  UserDefinedFunction [dbo].[GetLocalFromUTC]    Script Date: 3/23/2022 10:16:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetLocalFromUTC] (@MyDate [DATETIME],@UTCOffSet [INT],@UseDayLightSavings [BIT]) RETURNS DATETIME
AS
BEGIN
	DECLARE @Local DATETIME = DATEADD(HOUR, @UTCOffSet, @MyDate)
	
	IF @UseDayLightSavings = 1 AND @Local >= [dbo].GetDSTStart(DATEPART(YEAR, @Local)) AND @Local < [dbo].GetDSTEnd(DATEPART(YEAR, @Local))
	BEGIN
		SET @Local = DATEADD(HOUR, 1, @Local)
	END

	RETURN @Local
END
GO
