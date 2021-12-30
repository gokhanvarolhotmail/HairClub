/* CreateDate: 07/28/2014 11:42:25.803 , ModifyDate: 07/28/2014 11:42:25.803 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  FUNCTION [dbo].[CombineDates] (
	@datepart	DATETIME,
	@timepart	DATETIME)
RETURNS DATETIME AS
BEGIN
	DECLARE @returnValue DATETIME

	IF @datepart IS NULL
		SET @datepart = CONVERT(DATETIME,0)

	IF @timepart IS NULL
		SET @timepart = CONVERT(DATETIME,0)

	SET @returnValue = DATEADD(MINUTE,DATEPART(MINUTE,@timepart),
				DATEADD(HOUR,DATEPART(HOUR,@timepart),
				DATEADD(DAY,DAY(@datepart) - 1,
				DATEADD(MONTH,MONTH(@datepart) - 1,
				DATEADD(YEAR,YEAR(@datepart) - 1900,
			CONVERT(DATETIME,0))))))

	RETURN @returnValue
END
GO
