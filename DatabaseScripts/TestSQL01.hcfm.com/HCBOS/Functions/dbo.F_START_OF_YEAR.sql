/* CreateDate: 10/03/2006 10:13:38.123 , ModifyDate: 10/03/2006 10:13:38.123 */
GO
create function dbo.F_START_OF_YEAR
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_YEAR
	Finds start of first day of year at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(yy,datediff(yy,0,@DAY),0)

end
GO
