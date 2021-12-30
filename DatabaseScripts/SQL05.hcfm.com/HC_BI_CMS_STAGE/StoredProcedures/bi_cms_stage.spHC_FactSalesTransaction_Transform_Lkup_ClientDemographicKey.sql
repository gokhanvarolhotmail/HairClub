/* CreateDate: 05/05/2015 15:26:07.040 , ModifyDate: 05/05/2015 15:26:07.040 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_ClientDemographicKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSalesTransaction_Transform_Lkup_SalesOrderKey] is used to determine
-- the SalesOrderKey foreign key values in the FactSalesTransaction table using DimSalesOrder.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesOrderKey] -1
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
		-- Update [SalesOrderKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SalesOrderKey] = COALESCE(DW.[SalesOrderKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW  WITH (NOLOCK)
			ON DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderKey], 0) = 0
			AND STG.[SalesOrderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_LoadInferred_DimSalesOrder] @DataPkgKey


		-----------------------
		-- Update SalesOrder Keys in STG
		-----------------------
		UPDATE STG SET
		     [SalesOrderKey] = COALESCE(DW.[SalesOrderKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrder] DW  WITH (NOLOCK)
			ON DW.[SalesOrderSSID] = STG.[SalesOrderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesOrderKey], 0) = 0
			AND STG.[SalesOrderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [SalesOrderKey]
		---------------------------
		----UPDATE STG SET
		----     [SalesOrderKey] = -1
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[SalesOrderKey] IS NULL

		---------------------------
		------ Fix [SalesOrderSSID]
		---------------------------
		----UPDATE STG SET
		----     [SalesOrderKey] = -1
		----     , [SalesOrderSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[SalesOrderSSID] IS NULL )

		-----------------------
		-- Exception if [SalesOrderSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrdeSSID is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesOrderSSID] IS NULL


		-----------------------
		-- Exception if [SalesOrderKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesOrderKey is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesOrderKey] IS NULL
				OR STG.[SalesOrderKey] = 0)


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
