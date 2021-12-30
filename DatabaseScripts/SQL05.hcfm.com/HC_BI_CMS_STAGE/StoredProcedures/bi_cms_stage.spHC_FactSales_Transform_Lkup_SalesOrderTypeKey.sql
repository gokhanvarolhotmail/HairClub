/* CreateDate: 05/03/2010 12:20:28.317 , ModifyDate: 10/26/2011 11:33:20.997 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSales_Transform_Lkup_SalesOrderTypeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSales_Transform_Lkup_SalesOrderTypeKey] is used to determine
-- the SalesOrderTypeKey foreign key values in the FactSales table using DimSalesOrderType.
--
--
--   exec [bi_cms_stage].[spHC_FactSales_Transform_Lkup_SalesOrderTypeKey] -1
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
		-- Update [SalesOrderTypeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SalesOrderTypeKey] = COALESCE(DW.[SalesOrderTypeKey], 0)
		FROM [bi_cms_stage].[FactSales] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderType] DW  WITH (NOLOCK)
			ON DW.[SalesOrderTypeSSID] = STG.[SalesOrderTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderTypeKey], 0) = 0
			AND STG.[SalesOrderTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSales_LoadInferred_DimSalesOrderType] @DataPkgKey


		-- Update SalesOrderType Keys in STG
		UPDATE STG SET
		     [SalesOrderTypeKey] = COALESCE(DW.[SalesOrderTypeKey], 0)
		FROM [bi_cms_stage].[FactSales] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderType] DW  WITH (NOLOCK)
			ON DW.[SalesOrderTypeSSID] = STG.[SalesOrderTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderTypeKey], 0) = 0
			AND STG.[SalesOrderTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [SalesOrderTypeKey]
		---------------------------
		----UPDATE STG SET
		----     [SalesOrderTypeKey] = -1
		----FROM [bi_cms_stage].[FactSales] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[SalesOrderTypeKey] IS NULL

		---------------------------
		------ Fix [SalesOrderTypeSSID]
		---------------------------
		----UPDATE STG SET
		----     [SalesOrderTypeKey] = -1
		----     , [SalesOrderTypeSSID] = -2
		----FROM [bi_cms_stage].[FactSales] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[SalesOrderTypeSSID] IS NULL )

		-----------------------
		-- Exception if [SalesOrderTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderTypeSSID is null - FSales_Trans_Lkup'
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderTypeSSID] IS NULL


		-----------------------
		-- Exception if [SalesOrderTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderTypeKey is null - FSales_Trans_Lkup'
		FROM [bi_cms_stage].[FactSales] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderTypeKey] IS NULL
				OR STG.[SalesOrderTypeKey] = 0)


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
