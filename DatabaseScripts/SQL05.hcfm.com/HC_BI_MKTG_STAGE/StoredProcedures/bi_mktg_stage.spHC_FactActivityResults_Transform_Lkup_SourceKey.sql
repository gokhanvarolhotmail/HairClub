/* CreateDate: 05/03/2010 12:26:55.287 , ModifyDate: 10/26/2011 10:42:17.343 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_SourceKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactActivityResults_Transform_Lkup_SourceKey] is used to determine
-- the SourceKey foreign key values in the FactActivityResults table using DimSource.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_SourceKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message

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

 	SET @TableName = N'[bi_mktg_dds].[DimSource]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
		       [SourceKey]  = -1
		     , [SourceSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SourceSSID] = '0' )

		------------------------
		-- There might be some other load that just added them
		-- Update [SourceKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SourceKey] = COALESCE(DW.[SourceKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				DW.[SourceSSID] = STG.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SourceKey], 0) = 0
			AND STG.[SourceSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimSource] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [SourceKey] = COALESCE(DW.[SourceKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				DW.[SourceSSID] = STG.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SourceKey], 0) = 0
			AND STG.[SourceSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [SourceKey]
		-----------------------
		UPDATE STG SET
		     [SourceKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SourceKey] IS NULL

		-----------------------
		-- Fix [SourceSSID]
		-----------------------
		UPDATE STG SET
		       [SourceKey]  = -1
		     , [SourceSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SourceSSID] IS NULL )

		-----------------------
		-- Exception if [SourceSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SourceSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SourceSSID] IS NULL


		-----------------------
		-- Exception if [SourceKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SourceKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SourceKey] IS NULL
				OR STG.[SourceKey] = 0)


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
