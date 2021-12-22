/* CreateDate: 10/03/2006 10:13:38.297 , ModifyDate: 10/03/2006 10:13:38.297 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function dbo.F_START_OF_10_MIN
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_10_MIN
	Finds beginning of 10 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

declare @BASE_DAY datetime
select  @BASE_DAY = dateadd(dd,datediff(dd,0,@Day),0)

return  dateadd(mi,(datediff(mi,@BASE_DAY,@Day)/10)*10,@BASE_DAY)

end
GO
