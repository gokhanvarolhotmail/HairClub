/* CreateDate: 05/03/2010 12:20:16.480 , ModifyDate: 05/03/2010 12:20:16.480 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrder_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrder_Transform] is used to transform records
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrder_Transform] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrder]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName

		-----------------------
		-- Transform CenterKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_CenterKey] @DataPkgKey

		-----------------------
		-- Transform ClientHomeCenteKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_ClientHomeCenterKey] @DataPkgKey

		-----------------------
		-- Transform ClientKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_ClientKey] @DataPkgKey

		-----------------------
		-- Transform ClientMembershipKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_ClientMembershipKey] @DataPkgKey

		-----------------------
		-- Transform EmployeeKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_EmployeeKey] @DataPkgKey

		-----------------------
		-- Transform RefundedSalesOrderKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_RefundedSalesOrderKey] @DataPkgKey

		-----------------------
		-- Transform SalesOrderTypeKey
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_SalesOrderTypeKey] @DataPkgKey


		-----------------------
		-- Set the ISNew and SCD fields
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DimSalesOrder_Transform_SetIsNewSCD] @DataPkgKey


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
