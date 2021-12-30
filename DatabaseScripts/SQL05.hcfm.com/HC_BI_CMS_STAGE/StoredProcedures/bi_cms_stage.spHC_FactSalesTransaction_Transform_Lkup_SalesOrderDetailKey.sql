/* CreateDate: 05/03/2010 12:20:25.793 , ModifyDate: 10/26/2011 11:41:38.323 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesOrderDetailKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSalesTransaction_Transform_Lkup_SalesOrderDetailKey] is used to determine
-- the SalesOrderDetailKey foreign key values in the FactSalesTransaction table using DimSalesOrderDetail.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesOrderDetailKey] -1
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
		-- Update [SalesOrderDetailKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SalesOrderDetailKey] = COALESCE(DW.[SalesOrderDetailKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW  WITH (NOLOCK)
			ON DW.[SalesOrderDetailSSID] = STG.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderDetailKey], 0) = 0
			AND STG.[SalesOrderDetailSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_LoadInferred_DimSalesOrderDetail] @DataPkgKey


		-----------------------
		-- Update SalesOrderDetail Keys in STG
		-----------------------
		UPDATE STG SET
		     [SalesOrderDetailKey] = COALESCE(DW.[SalesOrderDetailKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderDetail] DW  WITH (NOLOCK)
			ON DW.[SalesOrderDetailSSID] = STG.[SalesOrderDetailSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderDetailKey], 0) = 0
			AND STG.[SalesOrderDetailSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [SalesOrderDetailKey]
		---------------------------
		----UPDATE STG SET
		----     [SalesOrderDetailKey] = -1
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[SalesOrderDetailKey] IS NULL

		---------------------------
		------ Fix [SalesOrderDetailSSID]
		---------------------------
		----UPDATE STG SET
		----     [SalesOrderDetailKey] = -1
		----     , [SalesOrderDetailSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[SalesOrderDetailSSID] IS NULL )

		-----------------------
		-- Exception if [SalesOrderDetailSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderDetailSSID is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderDetailSSID] IS NULL


		-----------------------
		-- Exception if [SalesOrderDetailKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderDetailKey is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderDetailKey] IS NULL
				OR STG.[SalesOrderDetailKey] = 0)


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
