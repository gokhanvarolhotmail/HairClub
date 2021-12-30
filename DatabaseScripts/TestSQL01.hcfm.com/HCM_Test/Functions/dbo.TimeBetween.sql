/* CreateDate: 12/01/2006 15:39:35.303 , ModifyDate: 05/01/2010 14:48:08.777 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  FUNCTION [dbo].TimeBetween (
	@timeToCheck	datetime,
	@startTime	datetime,
	@endTime	datetime
				)
RETURNS bit AS
BEGIN
	/*Checks if the time portion of a supplied date is between the time portion of two other dates
	Ignores date portion of all parameters
	returns: 1=is between
		 0=is not between
	*/
	DECLARE @returnValue bit

	IF @timeToCheck IS NULL OR @startTime IS NULL OR @endTime IS NULL
		BEGIN
			SET @returnValue = 0
			RETURN @returnValue
		END

	SET @timeToCheck = dbo.CombineDates(null, @timeToCheck)
	SET @startTime   = dbo.CombineDates(null, @startTime)
	SET @endTime     = dbo.CombineDates(null, @endTime)

	IF @timeToCheck BETWEEN @startTime AND @endTime
		SET @returnValue = 1
	ELSE
		SET @returnValue = 0

	RETURN @returnValue
END
GO
