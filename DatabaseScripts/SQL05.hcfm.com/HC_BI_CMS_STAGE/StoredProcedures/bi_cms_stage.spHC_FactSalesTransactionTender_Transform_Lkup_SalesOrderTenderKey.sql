/* CreateDate: 05/03/2010 12:20:23.107 , ModifyDate: 10/31/2012 16:21:26.563 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransactionTender_Transform_Lkup_SalesOrderTenderKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSalesTransactionTender_Transform_Lkup_SalesOrderTenderKey] is used to determine
-- the SalesOrderTenderKey foreign key values in the FactSalesTransactionTender table using DimSalesOrderTender.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransactionTender_Transform_Lkup_SalesOrderTenderKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added Exception message
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
		-- Update [SalesOrderTenderKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SalesOrderTenderKey] = COALESCE(DW.[SalesOrderTenderKey], 0)
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderTender] DW  WITH (NOLOCK)
			ON DW.[SalesOrderTenderSSID] = STG.[SalesOrderTenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderTenderKey], 0) = 0
			AND STG.[SalesOrderTenderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey
			AND NOT  COALESCE(STG.[CDC_Operation],'')  ='D'
		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransactionTender_LoadInferred_DimSalesOrderTender] @DataPkgKey


		-----------------------
		-- Update SalesOrderTender Keys in STG
		-----------------------
		UPDATE STG SET
		     [SalesOrderTenderKey] = COALESCE(DW.[SalesOrderTenderKey], 0)
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderTender] DW  WITH (NOLOCK)
			ON DW.[SalesOrderTenderSSID] = STG.[SalesOrderTenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderTenderKey], 0) = 0
			AND STG.[SalesOrderTenderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey
			AND NOT  COALESCE(STG.[CDC_Operation],'')  ='D'

		-----------------------------
		-------- Fix [SalesOrderTenderKey]
		-----------------------------
		------UPDATE STG SET
		------     [SalesOrderTenderKey] = -1
		------FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		------WHERE STG.[DataPkgKey] = @DataPkgKey
		------	AND STG.[SalesOrderTenderKey] IS NULL

		-----------------------------
		-------- Fix [SalesOrderTenderSSID]
		-----------------------------
		------UPDATE STG SET
		------     [SalesOrderTenderKey] = -1
		------     , [SalesOrderTenderSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		------FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		------WHERE STG.[DataPkgKey] = @DataPkgKey
		------	AND (STG.[SalesOrderTenderSSID] IS NULL )

		-----------------------
		-- Exception if [SalesOrderTenderSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderTenderSSID is null - FSalesTnd_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderTenderSSID] IS NULL


		-----------------------
		-- Exception if [SalesOrderTenderKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesorderTenderKey is null - FSalesTnd_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderTenderKey] IS NULL
				OR STG.[SalesOrderTenderKey] = 0)


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
