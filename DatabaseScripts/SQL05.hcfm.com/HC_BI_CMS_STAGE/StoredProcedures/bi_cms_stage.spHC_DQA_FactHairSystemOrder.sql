/* CreateDate: 06/27/2011 17:23:51.783 , ModifyDate: 06/27/2011 17:23:51.783 */
GO
create PROCEDURE [bi_cms_stage].[spHC_DQA_FactHairSystemOrder]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DQA_FactHairSystemOrder] is used to perform the Data Quality
-- check on the data to be loaded into the data warehouse
--
--
--   exec [bi_cms_stage].[spHC_DQA_FactHairSystemOrder] 431
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'

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
				EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0000] @DataPkgKey
			END

		-----------------------
		-- Validate Rule 4 - DateKey Foreign Key not defined
		-----------------------
--		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0004] @DataPkgKey

		-----------------------
		-- Validate Rule 22 - CenterKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0022] @DataPkgKey

		-----------------------
		-- Validate Rule 102 - ClientKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0102] @DataPkgKey

		-----------------------
		-- Validate Rule 104 - ClientMembershipKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0104] @DataPkgKey

		-----------------------
		-- Validate Rule 140 - HairSystemDensityKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0140] @DataPkgKey

		-----------------------
		-- Validate Rule 141 - HairSystemDesignTemplateKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0141] @DataPkgKey

		-----------------------
		-- Validate Rule 142 - HairSystemFrontalDensityKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0142] @DataPkgKey

		-----------------------
		-- Validate Rule 143 - HairSystemHairLengthKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0143] @DataPkgKey

		-----------------------
		-- Validate Rule 144 - HairSystemMatrixColorKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0144] @DataPkgKey

		-----------------------
		-- Validate Rule 145 - HairSystemOrderStatusKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0145] @DataPkgKey

		-----------------------
		-- Validate Rule 146 - HairSystemRecessionKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0146] @DataPkgKey

		-----------------------
		-- Validate Rule 147 - HairSystemStyleKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0147] @DataPkgKey

		-----------------------
		-- Validate Rule 148 - HairSystemTextureKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0148] @DataPkgKey

		-----------------------
		-- Validate Rule 149 - HairSystemTypeKey Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0149] @DataPkgKey

		-----------------------
		-- Validate Rule 151 - HairSystemCapSize Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0151] @DataPkgKey

		-----------------------
		-- Validate Rule 152 - HairSystemHairColor Foreign Key not defined
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_FactHairSystemOrder_0152] @DataPkgKey



		-----------------------
		-- Flag records as Healthy
		-----------------------
		UPDATE STG SET
			IsHealthy = 1
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE DataPkgKey = @DataPkgKey
		AND IsRejected = 0
		AND IsAllowed = 0
		AND IsFixed = 0

		-----------------------
		-- Flag records as validated
		-----------------------
		UPDATE STG SET
			IsValidated = 1
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
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
