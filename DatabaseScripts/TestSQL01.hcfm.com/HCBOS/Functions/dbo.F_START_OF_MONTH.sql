/* CreateDate: 10/03/2006 10:13:38.170 , ModifyDate: 10/03/2006 10:13:38.170 */
GO
create function dbo.F_START_OF_MONTH
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_MONTH
	Finds start of first day of month at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(mm,datediff(mm,0,@DAY),0)

end
GO
