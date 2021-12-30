/* CreateDate: 05/03/2010 12:26:49.977 , ModifyDate: 05/03/2010 12:26:49.977 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DQA_FactActivityResults]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DQA_FactActivityResults] is used to perform the Data Quality
-- check on the data to be loaded into the data warehouse
--
--
--   exec [bi_mktg_stage].[spHC_DQA_FactActivityResults] 431
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'

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
				EXEC	@return_value = [bi_mktg_stage].[spHC_DQA_FactActivityResults_0000] @DataPkgKey
			END

		-----------------------
		-- Validate Rule 4 - DateKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_DQA_FactActivityResults_0004] @DataPkgKey

		-----------------------
		-- Validate Rule 6 - TimeOfDayKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_DQA_FactActivityResults_0006] @DataPkgKey

		-----------------------
		-- Validate Rule 22 - CenterKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_DQA_FactActivityResults_0022] @DataPkgKey

		-----------------------
		-- Validate Rule 1002 - ActivityKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_DQA_FactActivityResults_1002] @DataPkgKey

		-----------------------
		-- Validate Rule 1018 - ContactKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_DQA_FactActivityResults_1018] @DataPkgKey


		-----------------------
		-- Flag records as Healthy
		-----------------------
		UPDATE STG SET
			IsHealthy = 1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE DataPkgKey = @DataPkgKey
		AND IsRejected = 0
		AND IsAllowed = 0
		AND IsFixed = 0

		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsValidated = 1
		FROM [bi_mktg_stage].[FactActivityResults] STG
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
