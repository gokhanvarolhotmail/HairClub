/* CreateDate: 07/05/2007 10:20:56.150 , ModifyDate: 05/01/2010 14:48:09.203 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  FUNCTION [dbo].CombineDates (
	@datepart	datetime,
	@timepart	datetime)
RETURNS datetime AS
BEGIN
	DECLARE @returnValue datetime

	if @datepart is null
		set @datepart = convert(datetime,0)

	if @timepart is null
		set @timepart = convert(datetime,0)

	SET @returnValue = dateadd(minute,datepart(minute,@timepart),
				dateadd(hour,datepart(hour,@timepart),
				dateadd(day,day(@datepart) - 1,
				dateadd(month,month(@datepart) - 1,
				dateadd(year,year(@datepart) - 1900,
			convert(datetime,0))))))

	RETURN @returnValue
END
GO
