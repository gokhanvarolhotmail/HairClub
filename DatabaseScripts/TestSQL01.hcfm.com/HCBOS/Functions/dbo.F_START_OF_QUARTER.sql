/* CreateDate: 10/03/2006 10:13:38.140 , ModifyDate: 10/03/2006 10:13:38.140 */
GO
create function dbo.F_START_OF_QUARTER
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_QUARTER
	Finds start of first day of quarter at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return   dateadd(qq,datediff(qq,0,@DAY),0)

end
GO
