/* CreateDate: 05/03/2010 12:26:59.927 , ModifyDate: 02/15/2021 10:09:53.223 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Transform_SetIsNewUpdDel]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivity_Transform_SetIsNewUpdDel] is used to determine
-- the SetIsNewUpdDel
--
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Transform_SetIsNewUpdDel] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			02/15/2021  KMurdoch     Removed reference to ActivitySSID
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
				, @return_value		int

	DECLARE		@TableName			varchar(150)	-- Name of table
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_mktg_dds].[FactActivity]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		-----------------------
		-- Check for new and existing rows
		-----------------------
		UPDATE STG SET
			IsNew = CASE WHEN DW.[ActivityKey] IS NULL
					THEN 1 ELSE 0 END
			,IsUpdate = CASE WHEN DW.[ActivityKey] IS NOT NULL
					THEN 1 ELSE 0 END

		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_FactActivity] DW ON
				DW.[ActivityKey] = STG.[ActivityKey]
		WHERE STG.[DataPkgKey] = @DataPkgKey;

		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  STG.SFDC_TaskID
					, IsDuplicate
					, row_number() OVER ( PARTITION BY SFDC_TaskID ORDER BY SFDC_TaskID ) AS RowNum
			   FROM  [bi_mktg_stage].[FactActivity] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)
			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1



		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF

		-- Cleanup temp tables

		-- Return success
		RETURN 0
	END TRY
    BEGIN CATCH
		-- Save original error number
		SET @intError = ERROR_NUMBER();

		-- Log the error
		EXECUTE [bief_stage].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;

		-- Re Raise the error
		EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList;

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF
		-- Cleanup temp tables

		-- Return the error number
		RETURN @intError;
    END CATCH


END
GO
