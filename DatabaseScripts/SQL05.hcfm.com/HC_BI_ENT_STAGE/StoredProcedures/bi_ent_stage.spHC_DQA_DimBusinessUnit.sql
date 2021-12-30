/* CreateDate: 05/03/2010 12:10:02.120 , ModifyDate: 03/26/2018 15:53:41.543 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DQA_DimBusinessUnit]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DQA_DimBusinessUnit] is used to perform the Data Quality
-- check on the data to be loaded into the data warehouse
--
--
--   exec [bi_ent_stage].[spHC_DQA_DimBusinessUnit] 431
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			03/26/2018  KMurdoch	 commented out code
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

 	SET @TableName = N'[bi_ent_dds].[DimBusinessUnit]'
/*

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
				EXEC	@return_value = [bi_ent_stage].[spHC_DQA_DimBusinessUnit_0000] @DataPkgKey
			END

		-----------------------
		-- Validate Rule 4 - BusinessUnitBrandKey cannot be NULL
		-----------------------
		EXEC	@return_value = [bi_ent_stage].[spHC_DQA_DimBusinessUnit_0010] @DataPkgKey


		-----------------------
		-- Flag records as Healthy
		-----------------------
		UPDATE STG SET
			IsHealthy = 1
		FROM [bi_ent_stage].[DimBusinessUnit] STG
		WHERE DataPkgKey = @DataPkgKey
		AND IsRejected = 0
		AND IsAllowed = 0
		AND IsFixed = 0



		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsValidated = 1
		FROM [bi_ent_stage].[DimBusinessUnit] STG
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
	*/

END
GO
