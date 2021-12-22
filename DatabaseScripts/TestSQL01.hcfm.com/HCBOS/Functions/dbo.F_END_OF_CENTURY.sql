/* CreateDate: 10/03/2006 10:25:52.370 , ModifyDate: 10/03/2006 10:25:52.370 */
GO
create function dbo.F_END_OF_CENTURY
	( @DAY datetime )
returns  datetime
as
/*
Function: F_END_OF_CENTURY
	Finds start of last day of century at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes
*/
begin

return   dateadd(yy,99-(year(@day)%100),dateadd(yy,datediff(yy,-1,@DAY),-1))

end
GO
