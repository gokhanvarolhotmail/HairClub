/* CreateDate: 01/25/2010 11:09:10.147 , ModifyDate: 05/01/2010 14:48:11.587 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE OncScriptCandidateForeignKeys AS
BEGIN
	SET NOCOUNT ON

	DECLARE @foreign_table_name  sysname
	DECLARE @foreign_column_name sysname
	DECLARE @primary_table_name  sysname
	DECLARE @primary_column_name sysname
	DECLARE @sql_text nvarchar(4000)

	DECLARE  best_candidate_foreign_keys CURSOR FOR
	SELECT   foreign_table_name,
	         foreign_column_name,
	         primary_table_name,
	         primary_column_name
	FROM     oncv_best_candidate_foreign_key
	ORDER BY foreign_table_name,
	         foreign_column_name

	OPEN  best_candidate_foreign_keys

	FETCH best_candidate_foreign_keys
	INTO  @foreign_table_name,
	      @foreign_column_name,
	      @primary_table_name,
	      @primary_column_name

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @sql_text =
			'ALTER TABLE ' + @foreign_table_name + '' + CHAR(13) + CHAR(10) +
			'WITH NOCHECK ADD CONSTRAINT ' + @foreign_table_name + '_fk_' + @foreign_column_name + CHAR(13) + CHAR(10) +
			'FOREIGN KEY (' + @foreign_column_name + ')' + CHAR(13) + CHAR(10) +
			'REFERENCES ' + @primary_table_name + ' (' + @primary_column_name + ')' + CHAR(13) + CHAR(10) +
			'ON DELETE NO ACTION' + CHAR(13) + CHAR(10) +
			'ON UPDATE NO ACTION;' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

		PRINT @sql_text

		FETCH best_candidate_foreign_keys
		INTO  @foreign_table_name,
		      @foreign_column_name,
		      @primary_table_name,
			  @primary_column_name
	END

	CLOSE      best_candidate_foreign_keys
	DEALLOCATE best_candidate_foreign_keys
END
GO
