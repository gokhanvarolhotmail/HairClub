/* CreateDate: 10/03/2006 10:13:38.280 , ModifyDate: 10/03/2006 10:13:38.280 */
GO
create function dbo.F_START_OF_15_MIN
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_15_MIN
	Finds beginning of 15 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

declare @BASE_DAY datetime
select  @BASE_DAY = dateadd(dd,datediff(dd,0,@Day),0)

return  dateadd(mi,(datediff(mi,@BASE_DAY,@Day)/15)*15,@BASE_DAY)

end
GO
