/* CreateDate: 05/03/2010 12:26:55.130 , ModifyDate: 10/26/2011 10:37:42.040 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_CompletedByEmployeeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactActivityResults_Transform_Lkup_CompletedByEmployeeKey] is used to determine
-- the CompletedByEmployeeKey foreign key values in the FactActivityResults table using DimEmployee.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_CompletedByEmployeeKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- There might be some other load that just added them
		-- Update [CompletedByEmployeeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [CompletedByEmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[CompletedByEmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CompletedByEmployeeKey], 0) = 0
			AND STG.[CompletedByEmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimEmployee_CompletedByEmployee] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [CompletedByEmployeeKey] = COALESCE(DW.[EmployeeKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[CompletedByEmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CompletedByEmployeeKey], 0) = 0
			AND STG.[CompletedByEmployeeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [CompletedByEmployeeKey]
		-----------------------
		UPDATE STG SET
		     [CompletedByEmployeeKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CompletedByEmployeeKey] IS NULL

		-----------------------
		-- Fix [CompletedByEmployeeSSID]
		-----------------------
		UPDATE STG SET
		       [CompletedByEmployeeKey]  = -1
		     , [CompletedByEmployeeSSID] = -2
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CompletedByEmployeeSSID] IS NULL )

		-----------------------
		-- Exception if [CompletedByEmployeeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'CompletedByEmployeeSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CompletedByEmployeeSSID] IS NULL


		-----------------------
		-- Exception if [CompletedByEmployeeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'CompletedByEmployeeKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CompletedByEmployeeKey] IS NULL
				OR STG.[CompletedByEmployeeKey] = 0)


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
