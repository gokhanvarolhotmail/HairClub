/* CreateDate: 01/25/2010 10:17:48.190 , ModifyDate: 05/01/2010 14:48:11.680 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE  PROCEDURE [dbo].[onc_sql_return_int] (
@sql_statement   char(4000),
@return_int   int OUTPUT)
AS
BEGIN

SET NOCOUNT ON
SET @return_int = 0
create table #tmp_integer(
	return_int	int null,
)

SET @sql_statement = 'insert into #tmp_integer ' + @sql_statement
exec (@sql_statement)

if ( (select count(*) from #tmp_integer) > 0 )
BEGIN
	select @return_int = (select max(return_int) from #tmp_integer)
END

drop table #tmp_integer

END
GO
