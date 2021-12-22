/* CreateDate: 11/09/2016 12:17:41.047 , ModifyDate: 11/09/2016 12:17:41.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION GetDSTEnd ( @Year AS INT )
RETURNS DATETIME
AS
BEGIN
    DECLARE @StartOfMonth DATETIME
    ,       @DstEnd DATETIME

	IF @Year <= 2006
	BEGIN
		DECLARE @DaysToSubtract INT

		-- Last Sunday of October
		SET @StartOfMonth = DATEADD(MONTH, 10, DATEADD(YEAR, @Year - 1900, 0))
		SET @DaysToSubtract = DATEPART(dw, @StartOfMonth) - 1

		IF @DaysToSubtract = 0
		BEGIN
			SET @DaysToSubtract = 7
		END

		SET @DstEnd = DATEADD(HOUR, 2, DATEADD(DAY, ( @DaysToSubtract * -1 ), @StartOfMonth))
	END

	ELSE
	BEGIN
		-- First Sunday of November
		SET @StartOfMonth = DATEADD(MONTH, 10, DATEADD(YEAR, @Year - 1900, 0))
		SET @DstEnd = DATEADD(HOUR, 2, DATEADD(DAY, ( ( 8 - DATEPART(dw, @StartOfMonth) ) % 7 ), @StartOfMonth))
	END

    RETURN @DstEnd
END
GO
