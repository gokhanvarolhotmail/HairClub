/* CreateDate: 05/03/2010 12:26:55.270 , ModifyDate: 10/27/2011 17:11:11.177 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_SalesTypeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform_Lkup_SalesTypeKey] is used to determine
-- the SalesTypeKey foreign key values in the FactActivityResults table using DimSalesType.
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_SalesTypeKey] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimSalesType]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
			   [SalesTypeKey] = -1
		     , [SalesTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE COALESCE(STG.[SalesTypeSSID],'0') = '0'
			AND STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [SalesTypeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SalesTypeKey] = COALESCE(DW.[SalesTypeKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSalesType] DW ON
				DW.[SalesTypeSSID] = STG.[SalesTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesTypeKey], 0) = 0
			AND STG.[SalesTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_LoadInferred_DimSalesType] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [SalesTypeKey] = COALESCE(DW.[SalesTypeKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSalesType] DW ON
				DW.[SalesTypeSSID] = STG.[SalesTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesTypeKey], 0) = 0
			AND STG.[SalesTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [SalesTypeKey]
		-----------------------
		UPDATE STG SET
		     [SalesTypeKey] = -1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesTypeKey] IS NULL

		-----------------------
		-- Fix [SalesTypeSSID]
		-----------------------
		UPDATE STG SET
		       [SalesTypeKey]  = -1
		     , [SalesTypeSSID] = -2
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesTypeSSID] IS NULL )

		-----------------------
		-- Exception if [SalesTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SalesTypeSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesTypeSSID] IS NULL


		-----------------------
		-- Exception if [SalesTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SalesTypeKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesTypeKey] IS NULL
				OR STG.[SalesTypeKey] = 0)


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
