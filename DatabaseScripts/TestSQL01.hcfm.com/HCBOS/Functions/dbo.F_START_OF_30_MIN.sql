/* CreateDate: 10/03/2006 10:13:38.233 , ModifyDate: 10/03/2006 10:13:38.233 */
GO
create function dbo.F_START_OF_30_MIN
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_30_MIN
	Finds beginning of 30 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

declare @BASE_DAY datetime
select  @BASE_DAY = dateadd(dd,datediff(dd,0,@Day),0)

return  dateadd(mi,(datediff(mi,@BASE_DAY,@Day)/30)*30,@BASE_DAY)

end
GO
