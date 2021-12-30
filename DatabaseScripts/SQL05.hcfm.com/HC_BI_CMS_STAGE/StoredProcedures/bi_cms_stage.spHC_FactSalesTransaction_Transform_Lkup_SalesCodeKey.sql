/* CreateDate: 05/03/2010 12:20:25.763 , ModifyDate: 10/26/2011 11:40:59.597 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesCodeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSalesTransaction_Transform_Lkup_SalesCodeKey] is used to determine
-- the SalesCodeKey foreign key values in the FactSalesTransaction table using DimSalesCode.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesCodeKey] -1
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
		-- Update [SalesCodeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SalesCodeKey] = COALESCE(DW.[SalesCodeKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesCode] DW  WITH (NOLOCK)
			ON DW.[SalesCodeSSID] = STG.[SalesCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesCodeKey], 0) = 0
			AND STG.[SalesCodeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_LoadInferred_DimSalesCode] @DataPkgKey


		-----------------------
		-- Update SalesCode Keys in STG
		-----------------------
		UPDATE STG SET
		     [SalesCodeKey] = COALESCE(DW.[SalesCodeKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesCode] DW  WITH (NOLOCK)
			ON DW.[SalesCodeSSID] = STG.[SalesCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesCodeKey], 0) = 0
			AND STG.[SalesCodeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [SalesCodeKey]
		---------------------------
		----UPDATE STG SET
		----     [SalesCodeKey] = -1
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[SalesCodeKey] IS NULL

		---------------------------
		------ Fix [SalesCodeSSID]
		---------------------------
		----UPDATE STG SET
		----     [SalesCodeKey] = -1
		----     , [SalesCodeSSID] = -2
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[SalesCodeSSID] IS NULL )

		-----------------------
		-- Exception if [SalesCodeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesCodeSSID is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesCodeSSID] IS NULL


		-----------------------
		-- Exception if [SalesCodeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'SalesCodeKey is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesCodeKey] IS NULL
				OR STG.[SalesCodeKey] = 0)


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
