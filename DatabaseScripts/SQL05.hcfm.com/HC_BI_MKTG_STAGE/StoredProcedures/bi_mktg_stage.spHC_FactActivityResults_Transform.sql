/* CreateDate: 05/03/2010 12:26:54.800 , ModifyDate: 08/09/2011 13:41:22.040 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform] is used to transform records
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform] 422
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

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName

		-----------------------
		-- Lookup the foreign keys for the dimensions on the fact table
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityResultDateKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityResultKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityResultTimeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityDateKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityTimeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityCompletedDateKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityCompletedTimeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityDueDateKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityStartTimeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_OriginalAppointmentDateKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivitySavedDateKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivitySavedTimeKey] @DataPkgKey




		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_GenderKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_EthnicityKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_OccupationKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_MaritalStatusKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_AgeRangeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_HairLossTypeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_CenterKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ContactKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_SourceKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActionCodeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ResultCodeKey] @DataPkgKey


		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_SalesTypeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_CompletedByEmployeeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_ActivityEmployeeKey] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_LASS] @DataPkgKey

		EXEC	@return_value = [bi_mktg_stage].[spHC_FactActivityResults_Transform_SetIsNewUpdDel] @DataPkgKey

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
