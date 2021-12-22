/* CreateDate: 10/03/2006 10:13:38.187 , ModifyDate: 10/03/2006 10:13:38.187 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function dbo.F_START_OF_DAY
	( @DAY datetime )
returns  datetime
as
/*
Function: F_START_OF_DAY
	Finds start of day at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes
*/
begin

return  dateadd(dd,datediff(dd,0,@DAY),0)

end
GO
