/* CreateDate: 12/03/2007 12:19:36.050 , ModifyDate: 05/01/2010 14:48:11.647 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Matt Wegner (ONC)
-- Create date: 2007-11-26
-- Description:	Update to a new user_code in all tables
-- - Requires both @from_user_code and @to_user_code be present
-- -  in onca_user prior to execution

--exec onc_UpdateUserCode '885','258'
-- =============================================
CREATE PROCEDURE [dbo].[onc_UpdateUserCode]
	@from_user_code nvarchar(20) ,
	@to_user_code nvarchar(20)
AS
BEGIN
	DECLARE @msgtext nvarchar(100)
	IF ISNULL(@from_user_code,'') = ''
	BEGIN
		SET @msgtext = ' FROM User not supplied'
		RAISERROR(@msgtext,0,1)
		RETURN
	END

	IF ISNULL(@to_user_code,'') = ''
	BEGIN
		SET @msgtext = ' TO User not supplied'
		RAISERROR(@msgtext,0,1)
		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM onca_user WHERE user_code = @from_user_code)
	BEGIN
		SET @msgtext = ' ' + @from_user_code + ' does not exist in onca_user'
		RAISERROR(@msgtext,0,1)
		RETURN
	END

	IF NOT EXISTS (SELECT 1 FROM onca_user WHERE user_code = @to_user_code)
	BEGIN
		SET @msgtext = ' ' + @to_user_code + ' does not exist in onca_user'
		RAISERROR(@msgtext,0,1)
		RETURN
	END

	DECLARE @tablename nvarchar(255)
	DECLARE @colname   nvarchar(255)
	DECLARE @constraintname nvarchar(255)
	DECLARE @sqlstatement nvarchar(2000)
	DECLARE @anyerror  int
	SET @anyerror = 0

	BEGIN TRAN
	SET NOCOUNT OFF
	--Find all fields like '%user_code' in user tables and update them with supplied user code
	DECLARE candidate_tables_columns CURSOR FAST_FORWARD FOR
		SELECT syscolumns.name colname, sysobjects.name tabname FROM syscolumns INNER JOIN sysobjects ON sysobjects.id = syscolumns.id
			WHERE syscolumns.name LIKE '%user_code' and sysobjects.xtype='U' AND sysobjects.name <> 'onca_user'
			ORDER BY sysobjects.name, syscolumns.name

	OPEN candidate_tables_columns
	FETCH NEXT FROM candidate_tables_columns INTO @colname, @tablename
	WHILE @@FETCH_STATUS = 0
		BEGIN
			SET @sqlstatement = 'UPDATE '+@tablename+' SET '+@colname+'='''+@to_user_code+''' WHERE '+@colname+'='''+@from_user_code+''''
			PRINT @sqlstatement
			EXEC (@sqlstatement)
			IF @@ERROR <> 0
				SET @anyerror = 1

			FETCH NEXT FROM candidate_tables_columns INTO @colname, @tablename
		END

	CLOSE candidate_tables_columns
	DEALLOCATE candidate_tables_columns

	SET NOCOUNT ON

	IF @anyerror = 1
		BEGIN
			SET @msgtext = ' Error Encountered during processing.  All modifications are cancelled.'
			RAISERROR(@msgtext,0,1)
			ROLLBACK TRAN
		END
	ELSE
		COMMIT TRAN

END
GO
