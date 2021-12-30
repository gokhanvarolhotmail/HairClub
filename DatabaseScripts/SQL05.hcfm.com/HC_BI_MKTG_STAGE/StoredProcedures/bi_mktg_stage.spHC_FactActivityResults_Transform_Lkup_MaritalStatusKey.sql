/* CreateDate: 05/03/2010 12:26:55.210 , ModifyDate: 10/26/2011 10:40:06.800 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_MaritalStatusKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactActivityResults_Transform_Lkup_MaritalStatusKey] is used to determine
-- the MaritalStatusKey foreign key values in the FactActivityResults table using DimMaritalStatus.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_MaritalStatusKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimMaritalStatus]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
		       [MaritalStatusKey]  = -1
		     , [MaritalStatusSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE COALESCE(STG.[MaritalStatusSSID], '0') = '0'
			AND STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [MaritalStatusKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [MaritalStatusKey] = COALESCE(DW.[MaritalStatusKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimMaritalStatus] DW ON
				DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[MaritalStatusKey], 0) = 0
			AND STG.[MaritalStatusSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimMaritalStatus] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [MaritalStatusKey] = COALESCE(DW.[MaritalStatusKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimMaritalStatus] DW ON
				DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[MaritalStatusKey], 0) = 0
			AND STG.[MaritalStatusSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [MaritalStatusKey]
		-----------------------
		UPDATE STG SET
		     [MaritalStatusKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[MaritalStatusKey] IS NULL

		-----------------------
		-- Fix [MaritalStatusSSID]
		-----------------------
		UPDATE STG SET
		       [MaritalStatusKey]  = -1
		     , [MaritalStatusSSID] = -2
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[MaritalStatusSSID] IS NULL )

		-----------------------
		-- Exception if [MaritalStatusSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'MaritalStatusSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[MaritalStatusSSID] IS NULL


		-----------------------
		-- Exception if [MaritalStatusKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'MaritalStatusKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[MaritalStatusKey] IS NULL
				OR STG.[MaritalStatusKey] = 0)

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
