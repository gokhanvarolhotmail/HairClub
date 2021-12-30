/* CreateDate: 05/03/2010 12:26:54.960 , ModifyDate: 08/06/2019 15:52:18.900 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityResultKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform_Lkup_ActivityResultKey] is used to determine
-- the ActivityResultKey foreign key values in the FactActivityResults table using DimActivityResult.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityResultKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		------------------------
		-- There might be some other load that just added them
		-- Update [ActivityResultKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ActivityResultKey] = COALESCE(DW.[ActivityResultKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityResult] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
				--DW.[ActivityResultSSID] = STG.[ActivityResultSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ActivityResultKey], 0) = 0
			AND STG.[ActivityResultSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimActivityResult] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [ActivityResultKey] = COALESCE(DW.[ActivityResultKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityResult] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
				--DW.[ActivityResultSSID] = STG.[ActivityResultSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ActivityResultKey], 0) = 0
			AND STG.[ActivityResultSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [ActivityResultKey]
		-----------------------
		UPDATE STG SET
		     [ActivityResultKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityResultKey] IS NULL

		-----------------------
		-- Fix [ActivityResultSSID]
		-----------------------
		UPDATE STG SET
		     [ActivityResultKey] = -1
		     , [ActivityResultSSID] = -2
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ActivityResultSSID] IS NULL )

		-----------------------
		-- Exception if [ActivityResultSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ActivityResultSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityResultSSID] IS NULL


		-----------------------
		-- Exception if [ActivityResultKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ActivityResultKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ActivityResultKey] IS NULL
				OR STG.[ActivityResultKey] = 0)


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
