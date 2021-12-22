/* CreateDate: 10/03/2006 10:25:52.433 , ModifyDate: 10/03/2006 10:25:52.433 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function dbo.F_END_OF_MONTH
	( @DAY datetime )
returns  datetime
as
/*
Function: F_END_OF_MONTH
	Finds start of last day of month at 00:00:00.000
	for input datetime, @DAY.
	Valid for all SQL Server datetimes.
*/
begin

return  dateadd(mm,datediff(mm,-1,@DAY),-1)

end
GO
