/****** Object:  UserDefinedFunction [dbo].[GetLocalFromUTC]    Script Date: 1/7/2022 4:05:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetLocalFromUTC] (@MyDate [DATETIME],@UTCOffSet [INT],@UseDayLightSavings [BIT],@DSTStart [DATETIME],@DSTEnd [DATETIME]) RETURNS DATETIME
AS
BEGIN
    -- Declare the return variable here
DECLARE @Local DATETIME = DATEADD(HOUR, @UTCOffSet, @MyDate)
DECLARE @Year INT = DATEPART(YEAR, @MyDate)




IF @UseDayLightSavings = 1 AND @Local >= @DSTStart AND @Local < @DSTEnd
BEGIN
SET @Local = DATEADD(HOUR, 1, @Local)
END


 

RETURN @Local
END
GO
