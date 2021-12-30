/* CreateDate: 05/03/2010 12:20:23.137 , ModifyDate: 10/26/2011 11:48:52.243 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransactionTender_Transform_Lkup_TenderTypeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSalesTransactionTender_Transform_Lkup_TenderTypeKey] is used to determine
-- the TenderTypeKey foreign key values in the FactSalesTransactionTender table using DimTenderType.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransactionTender_Transform_Lkup_TenderTypeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added exception message
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


 	-- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- There might be some other load that just added them
		-- Update [TenderTypeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [TenderTypeKey] = COALESCE(DW.[TenderTypeKey], 0)
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimTenderType] DW  WITH (NOLOCK)
			ON DW.[TenderTypeSSID] = STG.[TenderTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[TenderTypeKey], 0) = 0
			AND STG.[TenderTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransactionTender_LoadInferred_DimTenderType] @DataPkgKey


		-- Update TenderType Keys in STG
		UPDATE STG SET
		     [TenderTypeKey] = COALESCE(DW.[TenderTypeKey], 0)
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimTenderType] DW  WITH (NOLOCK)
			ON DW.[TenderTypeSSID] = STG.[TenderTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[TenderTypeKey], 0) = 0
			AND STG.[TenderTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------------
		-------- Fix [TenderTypeKey]
		-----------------------------
		------UPDATE STG SET
		------     [TenderTypeKey] = -1
		------FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		------WHERE STG.[DataPkgKey] = @DataPkgKey
		------	AND STG.[TenderTypeKey] IS NULL

		-----------------------------
		-------- Fix [TenderTypeSSID]
		-----------------------------
		------UPDATE STG SET
		------     [TenderTypeKey] = -1
		------     , [TenderTypeSSID] = -2
		------FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		------WHERE STG.[DataPkgKey] = @DataPkgKey
		------	AND (STG.[TenderTypeSSID] IS NULL )

		-----------------------
		-- Exception if [TenderTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'tenderTypeSSID is null - FSalesTnd_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[TenderTypeSSID] IS NULL


		-----------------------
		-- Exception if [TenderTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'TenderTypeKey is null - FSalesTnd_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[TenderTypeKey] IS NULL
				OR STG.[TenderTypeKey] = 0)


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
