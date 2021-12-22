/* CreateDate: 10/03/2006 10:13:38.250 , ModifyDate: 10/03/2006 10:13:38.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function dbo.F_START_OF_20_MIN
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_20_MIN
	Finds beginning of 20 minute period
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

declare @BASE_DAY datetime
select  @BASE_DAY = dateadd(dd,datediff(dd,0,@Day),0)

return  dateadd(mi,(datediff(mi,@BASE_DAY,@Day)/20)*20,@BASE_DAY)

end
GO
