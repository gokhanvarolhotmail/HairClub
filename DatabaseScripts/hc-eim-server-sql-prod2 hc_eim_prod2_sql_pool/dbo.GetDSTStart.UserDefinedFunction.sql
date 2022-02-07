/****** Object:  UserDefinedFunction [dbo].[GetDSTStart]    Script Date: 2/7/2022 10:45:34 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[GetDSTStart] (@Year [INT]) RETURNS DATETIME
AS
BEGIN
    DECLARE @StartOfMonth DATETIME
    ,       @DstStart DATETIME 


	IF @Year < 1987
	BEGIN
		DECLARE @DaysToSubtract INT

		-- Last Sunday of April
		SET @StartOfMonth = DATEADD(MONTH, 4, DATEADD(YEAR, @Year - 1900, 0))
		SET @DaysToSubtract = DATEPART(dw, @StartOfMonth) - 1

		IF @DaysToSubtract = 0
		BEGIN
			SET @DaysToSubtract = 7
		END

		SET @DstStart = DATEADD(HOUR, 2, DATEADD(DAY, ( @DaysToSubtract * -1 ), @StartOfMonth))	
	END
	
	ELSE IF ( @Year >= 1987 AND @Year <= 2006 )
	BEGIN
		-- First Sunday of April
		SET @StartOfMonth = DATEADD(MONTH, 3, DATEADD(YEAR, @Year - 1900, 0))
		SET @DstStart = DATEADD(HOUR, 2, DATEADD(DAY, ( ( 8 - DATEPART(dw, @StartOfMonth) ) % 7 ), @StartOfMonth))
	END
	
	ELSE
	BEGIN
		-- Second Sunday of March
		SET @StartOfMonth = DATEADD(MONTH, 2, DATEADD(YEAR, @Year - 1900, 0))
		SET @DstStart = DATEADD(HOUR, 2, DATEADD(DAY, ( ( 8 - DATEPART(dw, @StartOfMonth) ) % 7 ) + 7, @StartOfMonth))
	END    

    RETURN @DstStart
END
GO
