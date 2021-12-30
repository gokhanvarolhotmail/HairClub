/* CreateDate: 05/03/2010 12:20:19.773 , ModifyDate: 05/03/2010 12:20:19.773 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DQA_FactSalesTransactionTender] is used to perform the Data Quality
-- check on the data to be loaded into the data warehouse
--
--
--   exec [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender] 431
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/13/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactSalesTransactionTender]'

	-- Check if we should log the ZERO rule (Information)
	DECLARE @IsDQAInformationLoggingEnabled	bit
	SET @IsDQAInformationLoggingEnabled = 1
	SET @IsDQAInformationLoggingEnabled = (SELECT [bief_stage].[fn_IsDQAInformationLoggingEnabled]())


	BEGIN TRY


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ValidateStart] @DataPkgKey, @TableName


		IF (@IsDQAInformationLoggingEnabled = 1)
			BEGIN
				-----------------------
				-- Validate Rule 0 - Information
				-----------------------
				EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0000] @DataPkgKey
			END

		-----------------------
		-- Validate Rule 4 - DateKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0004] @DataPkgKey

		-----------------------
		-- Validate Rule 22 - CenterKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0022] @DataPkgKey

		-----------------------
		-- Validate Rule 102 - ClientKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0102] @DataPkgKey

		-----------------------
		-- Validate Rule 104 - ClientMembershipKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0104] @DataPkgKey

		-----------------------
		-- Validate Rule 116 - SalesOrderTypeKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0116] @DataPkgKey

		-----------------------
		-- Validate Rule 118 - TenderTypeKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0118] @DataPkgKey

		-----------------------
		-- Validate Rule 120 - SalesOrderKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0120] @DataPkgKey

		-----------------------
		-- Validate Rule 124 - SalesOrderTenderKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSalesTransactionTender_0124] @DataPkgKey


		-----------------------
		-- Flag records as Healthy
		-----------------------
		UPDATE STG SET
			IsHealthy = 1
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		WHERE DataPkgKey = @DataPkgKey
		AND IsRejected = 0
		AND IsAllowed = 0
		AND IsFixed = 0


		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsValidated = 1
		FROM [bi_cms_stage].[FactSalesTransactionTender] STG
		WHERE DataPkgKey = @DataPkgKey


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ValidateStop] @DataPkgKey, @TableName


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
