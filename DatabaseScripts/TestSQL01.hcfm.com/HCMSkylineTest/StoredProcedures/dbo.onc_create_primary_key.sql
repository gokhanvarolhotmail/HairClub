/* CreateDate: 06/23/2014 13:45:26.790 , ModifyDate: 06/23/2014 13:45:26.790 */
GO
CREATE  PROCEDURE [dbo].[onc_create_primary_key] (
@key_length int = 10,
@table_name varchar(128),
@column_name varchar(128),
@primary_key varchar(25) output,
@suffix char(10) = 'ONC' )
AS

Begin
DECLARE   @counter int, @seed int
DECLARE   @return varchar(25)
DECLARE   @row_count int
DECLARE   @sql_statement varchar(4000)

SET @counter = 0
SET @seed = DATEPART(ms, GETDATE())

if len(@suffix) > 0
	set @key_length = @key_length - len(@suffix)

WHILE  ( @counter = 0 )
BEGIN
	EXEC  [onc_generate_string] @key_length,@seed,@return OUTPUT

	if len(@suffix) > 0
		SET @return = RTRIM(@return) +  RTRIM(@suffix)

	SET @sql_statement = 'select count(*) from ' + RTRIM(@table_name) +
			     ' where ' +  Rtrim(@column_name)+  ' = ''' + Rtrim(@return) + ''''

	EXEC [onc_sql_return_int] @sql_statement, @row_count OUTPUT

	If @row_count > 0
		SET @seed = @seed *  3
	else
		SET @counter = 1
END

SELECT @primary_key = @return
end
GO
