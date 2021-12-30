/* CreateDate: 05/03/2010 12:26:49.880 , ModifyDate: 05/03/2010 12:26:49.880 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DQA_DimSalesType_Upsert]
			  @DataPkgKey				int
			, @RuleKey				int				-- Rule to Validate
			, @RuleActionKey		int				-- Key to RuleAction table
			, @RuleActionName		varchar(30)		-- Rule Action Name  (Allow,Fix,Reject)
			, @TableKey				int				-- Key to DQA table
			, @TableName			varchar(100)	-- Name of DQA table
			, @ViolationStatusKey	int				-- Key to Violation Status table


AS
-------------------------------------------------------------------------
-- [spHC_DQA_DimSalesType_Upsert]  loads data to Data Quality
-- table
--
--
--   exec [bi_mktg_stage].[spHC_DQA_DimSalesType_Upsert]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    04/06/2010  RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters

	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey
				, N'@RuleKey'
				, @RuleKey
				, N'@RuleActionKey'
				, @RuleActionKey
				, N'@RuleActionName'
				, @RuleActionName
				, N'@TableKey'
				, @TableKey
				, N'@TableName'
				, @TableName
				, N'@ViolationStatusKey'
				, @ViolationStatusKey

		-----------------------
		-- Check for new rows to put into DQA
		-----------------------
		UPDATE STG SET
		     [DataQualityAuditKey] = DQA.[DataQualityAuditKey]
			,IsNewDQA = CASE WHEN DQA.[DataQualityAuditKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimSalesType] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DQA_DimSalesType] DQA ON
				DQA.[SalesTypeSSID] = STG.[SalesTypeSSID]
				AND DQA.DataPkgKey = STG.DataPkgKey
		WHERE STG.DataPkgKey = @DataPkgKey

		-----------------------
		-- Put new rows into DQA
		-----------------------
		INSERT INTO [bi_mktg_stage].[synHC_DQA_DimSalesType]
					( [DataPkgKey]
					, [SalesTypeKey]
					, [SalesTypeSSID]
					, [SalesTypeDescription]
					, [SalesTypeDescriptionShort]
					, [ModifiedDate]
					, [IsNew]
					, [IsType1]
					, [IsType2]
					, [IsDelete]
					, [IsDuplicate]
					, [IsInferredMember]
					, [IsException]
					, [IsHealthy]
					, [IsRejected]
					, [IsAllowed]
					, [IsFixed]
					, [SourceSystemKey]
					)
			SELECT
					  [DataPkgKey]
					, [SalesTypeKey]
					, [SalesTypeSSID]
					, [SalesTypeDescription]
					, [SalesTypeDescriptionShort]
					, [ModifiedDate]
					, [IsNew]
					, [IsType1]
					, [IsType2]
					, [IsDelete]
					, [IsDuplicate]
					, [IsInferredMember]
					, [IsException]
					, [IsHealthy]
					, [IsRejected]
					, [IsAllowed]
					, [IsFixed]
					, [SourceSystemKey]
			FROM	[bi_mktg_stage].[DimSalesType] STG
			WHERE	RuleKey = @RuleKey
				AND	STG.[IsNewDQA] = 1
				AND STG.DataPkgKey = @DataPkgKey


		-----------------------
		-- Update DataQualityAuditKey of rows added
		-----------------------
		UPDATE STG SET
		     [DataQualityAuditKey] = DQA.[DataQualityAuditKey]
		FROM [bi_mktg_stage].[DimSalesType] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DQA_DimSalesType] DQA ON
				DQA.[SalesTypeSSID] = STG.[SalesTypeSSID]
				AND DQA.DataPkgKey = STG.DataPkgKey
		WHERE STG.DataPkgKey = @DataPkgKey

		-----------------------
		-- Put Violations in Violation Header table
		-----------------------
		INSERT INTO [bief_stage].[syn_DQ_Violation]
					( [RuleKey]
					, [RuleActionKey]
					, [ViolationStatusKey]
					, [TableKey]
					, [SourceSystemKey]
					, [DataQualityAuditKey]
					, [CreateTimestamp]
					, [UpdateTimestamp]
					)
			SELECT
				      @RuleKey
					, @RuleActionKey
					, @ViolationStatusKey
					, @TableKey
					, STG.[SourceSystemKey]
					, STG.[DataQualityAuditKey]
					, GETDATE()
					, GETDATE()
			FROM	[bi_mktg_stage].[DimSalesType] STG
			WHERE	STG.[RuleKey] = @RuleKey
				AND STG.DataPkgKey = @DataPkgKey


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
