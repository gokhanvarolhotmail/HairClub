/* CreateDate: 08/18/2015 10:54:28.160 , ModifyDate: 08/18/2015 10:54:28.160 */
GO
/*
==============================================================================
PROCEDURE:				extHairClubCMSCreatePrimaryKey

DESTINATION SERVER:		SQL03

DESTINATION DATABASE: 	HCM

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			08/07/15

DATE IMPLEMENTED: 		08/07/15

LAST REVISION DATE: 	08/07/15

==============================================================================
DESCRIPTION:	create an OnContact Primary Key
==============================================================================
NOTES:
		* 08/07/15 MVT - Created

==============================================================================
SAMPLE EXECUTION:
EXEC extHairClubCMSCreatePrimaryKey
==============================================================================
*/

CREATE PROCEDURE [dbo].[extHairClubCMSCreatePrimaryKey] (
@key_length int = 10,
@table_name varchar(128),
@column_name varchar(128),
@primary_key varchar(25) output,
@suffix char(10) = 'ONC' )
AS

BEGIN
	DECLARE   @counter int, @seed int
	DECLARE   @return varchar(25)
	DECLARE   @row_count int
	DECLARE   @sql_statement varchar(4000)

	SET @counter = 0
	SET @seed = DATEPART(ms, GETDATE())

	if len(@suffix) > 0
		set @key_length = @key_length - len(@suffix)

	WHILE (@counter = 0)
	  BEGIN
		EXEC onc_generate_string @key_length,@seed,@return OUTPUT

		IF LEN(@suffix) > 0
			SET @return = RTRIM(@return) +  RTRIM(@suffix)

		SET @sql_statement = 'select count(*) from ' + RTRIM(@table_name) +
					 ' where ' +  RTRIM(@column_name)+  ' = ''' + RTRIM(@return) + ''''

		EXEC onc_sql_return_int @sql_statement, @row_count OUTPUT

		IF @row_count > 0
			SET @seed = @seed *  3
		ELSE
			SET @counter = 1
	  END

	SELECT @primary_key = @return
END
GO
