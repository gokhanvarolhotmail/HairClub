/* CreateDate: 05/03/2010 12:20:19.740 , ModifyDate: 05/03/2010 12:20:19.740 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DQA_FactSales]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DQA_FactSales] is used to perform the Data Quality
-- check on the data to be loaded into the data warehouse
--
--
--   exec [bi_cms_stage].[spHC_DQA_FactSales] 431
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactSales]'

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
				EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0000] @DataPkgKey
			END

		-----------------------
		-- Validate Rule 4 - DateKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0004] @DataPkgKey

		-----------------------
		-- Validate Rule 22 - CenterKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0022] @DataPkgKey

		-----------------------
		-- Validate Rule 102 - ClientKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0102] @DataPkgKey

		-----------------------
		-- Validate Rule 104 - ClientMembershipKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0104] @DataPkgKey

		-----------------------
		-- Validate Rule 106 - EmployeeKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0106] @DataPkgKey

		-----------------------
		-- Validate Rule 108 - MembershipKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0108] @DataPkgKey

		-----------------------
		-- Validate Rule 116 - SalesOrderTypeKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0116] @DataPkgKey

		-----------------------
		-- Validate Rule 120 - SalesOrderKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactSales_0120] @DataPkgKey



		-----------------------
		-- Flag records as Healthy
		-----------------------
		UPDATE STG SET
			IsHealthy = 1
		FROM [bi_cms_stage].[FactSales] STG
		WHERE DataPkgKey = @DataPkgKey
		AND IsRejected = 0
		AND IsAllowed = 0
		AND IsFixed = 0

		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsValidated = 1
		FROM [bi_cms_stage].[FactSales] STG
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
