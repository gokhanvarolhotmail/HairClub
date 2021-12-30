/* CreateDate: 06/27/2011 17:23:38.197 , ModifyDate: 06/27/2011 17:23:38.197 */
GO
create PROCEDURE [bi_cms_stage].[spHC_DQA_DimHairSystemDensity_0000]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DQA_DimHairSystemDensity_0000] is used to perform the Data Quality
-- check on the data to be loaded into the data warehouse
--
--
--   exec [bi_cms_stage].[spHC_DQA_DimHairSystemDensity_0000]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/10/2011  EKnapp       Initial Creation
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

	DECLARE		  @RuleKey				int				-- Rule to Validate
				, @RuleActionKey		int				-- Key to RuleAction table
				, @RuleActionName		varchar(30)		-- Rule Action Name  (Allow,Fix,Reject)
				, @TableKey				int				-- Key to DQA table
				, @TableName			varchar(100)	-- Name of DQA table
				, @ViolationStatusKey	int				-- Key to Violation Status table

	SET @RuleKey = 0  --Log for Information
	SET @TableName = N'[bi_cms_dqa].[DimHairSystemDensity]'
	SET @ViolationStatusKey = 1
	SET @TableKey = 1



		-----------------------
		-- Get Rule Action key for Rule
		-----------------------
		SELECT @RuleActionKey = ra.RuleActionKey
				, @RuleActionName = UPPER(ra.RuleActionName)
		FROM [bief_stage].[syn_DQ_RuleAction] ra
		INNER JOIN [bief_stage].[syn_DQ_Rule] r ON r.RuleActionKey = ra.RuleActionKey
		WHERE r.RuleKey = @RuleKey




	BEGIN TRY

		-----------------------
		-- Check for General Exceptions
		-----------------------
		UPDATE STG SET
			RuleKey = @RuleKey
		FROM [bi_cms_stage].[DimHairSystemDensity] STG
		WHERE 1=1   --1=1 Rule is active  1=0 Rule is inactive
			AND DataPkgKey = @DataPkgKey
		-- Put other clauses here

		---------------------------
		------ Set the IsException flag to stop record from
		------ being loaded into the data warehouse
		---------------------------
		----IF (@RuleActionName = 'REJECT')
		----BEGIN
		----	UPDATE STG SET
		----		IsException = 1
		----	FROM [bi_cms_stage].[DimHairSystemDensity] STG
		----	WHERE RuleKey = @RuleKey
		----		AND DataPkgKey = @DataPkgKey
		----END

		---------------------------
		------ Allow records
		------ into the data warehouse
		---------------------------
		----IF (@RuleActionName = 'ALLOW')
		----BEGIN
		----	UPDATE STG SET
		----		IsAllowed = 1
		----	FROM [bi_cms_stage].[DimHairSystemDensity] STG
		----	WHERE RuleKey = @RuleKey
		----		AND DataPkgKey = @DataPkgKey
		----END

		---------------------------
		------ Fix records before loading
		------ into the data warehouse
		---------------------------
		----IF (@RuleActionName = 'FIX')
		----BEGIN
		----	UPDATE STG SET
		----		IsFixed = 1
		----		--Add fixes here

		----	FROM [bi_cms_stage].[DimHairSystemDensity] STG
		----	WHERE RuleKey = @RuleKey
		----		AND DataPkgKey = @DataPkgKey
		----END


		-----------------------
		-- Load records that are violations to Data Quality table
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_DimHairSystemDensity_Upsert] @DataPkgKey, @RuleKey, @RuleActionKey,
									@RuleActionName, @TableKey, @TableName, @ViolationStatusKey

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
