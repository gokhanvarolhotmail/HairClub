/* CreateDate: 01/05/2016 16:04:38.257 , ModifyDate: 08/08/2017 11:39:47.387 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[pso_onc_create_primary_key] (
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
DECLARE   @sql_statement nvarchar(4000)
DECLARE   @attempts int

SET @attempts = 0

SET @counter = 0
SET @seed = DATEPART(ms, GETDATE())

if len(@suffix) > 0
	set @key_length = @key_length - len(@suffix)

WHILE  ( @counter = 0 )
BEGIN
	EXEC  [onc_generate_string] @key_length,@seed,@return OUTPUT

	if len(@suffix) > 0
		SET @return = RTRIM(@return) +  RTRIM(@suffix)


	IF (@table_name = 'oncd_contact_address' AND @column_name = 'contact_address_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_contact_address WHERE contact_address_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_contact_phone' AND @column_name = 'contact_phone_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_contact_phone WHERE contact_phone_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_contact_email' AND @column_name = 'contact_email_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_contact_email WHERE contact_email_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_activity_contact' AND @column_name = 'activity_contact_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_activity_contact WHERE activity_contact_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_activity_user' AND @column_name = 'activity_user_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_activity_user WHERE activity_user_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_activity' AND @column_name = 'activity_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_activity WHERE activity_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_activity_company' AND @column_name = 'activity_company_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_activity_company WHERE activity_company_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE IF (@table_name = 'oncd_contact_company' AND @column_name = 'contact_company_id')
	BEGIN
		SELECT @row_count = (CASE WHEN EXISTS (SELECT 1 FROM oncd_contact_company WHERE contact_company_id = RTRIM(@return)) THEN 1 ELSE 0 END)
	END
	ELSE
	BEGIN
		--SET @sql_statement = 'select count(*) from ' + RTRIM(@table_name) +
		--		     ' where ' +  Rtrim(@column_name)+  ' = ''' + Rtrim(@return) + ''''
 		SET @sql_statement = N'SELECT @return = (CASE WHEN EXISTS (select 1 from ' + RTRIM(@table_name) +
					 ' where ' +  Rtrim(@column_name)+  ' = ''' + Rtrim(@return) + ''') THEN 1 ELSE 0 END)'

		--EXEC [onc_sql_return_int] @sql_statement, @row_count OUTPUT
		EXEC sp_executesql @sql_statement, N'@return int OUTPUT', @row_count OUTPUT
	END
SET @attempts = @attempts + 1
	If @row_count > 0
		SET @seed = @seed + 1
--		SET @seed = @seed *  3
	else
		SET @counter = 1
END

SELECT @primary_key = @return

RETURN @attempts
end
GO
