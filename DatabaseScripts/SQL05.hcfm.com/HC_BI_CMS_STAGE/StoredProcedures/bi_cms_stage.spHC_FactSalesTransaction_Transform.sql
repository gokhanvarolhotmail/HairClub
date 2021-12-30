/* CreateDate: 05/03/2010 12:20:25.543 , ModifyDate: 05/03/2010 12:20:25.543 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_FactSalesTransaction_Transform] is used to transform records
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Transform] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
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

	DECLARE		  @TableName			varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransaction]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName

		-----------------------
		-- Lookup the foreign keys for the dimensions on the fact table
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_CenterKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_ClientKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_ClientMembershipKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_OrderDateKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_1] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_2] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_3] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_EmployeeKey_4] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesCodeKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesOrderKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesOrderDetailKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_SalesOrderTypeKey] @DataPkgKey


		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_Transform_SetIsNewUpdDel] @DataPkgKey


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStop] @DataPkgKey, @TableName

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
