/* CreateDate: 10/05/2010 14:04:37.090 , ModifyDate: 10/05/2010 14:04:37.090 */
GO
CREATE PROCEDURE [bi_cms_stage].[spSTG_UnitTest_DimAccumulator]


AS
-------------------------------------------------------------------------
-- [spSTG_UnitTest_DimAccumulator] is used to Unit Test
-- DimAccumulator
--
--
--   exec [bi_cms_stage].[spSTG_UnitTest_DimAccumulator]
--
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--
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

	DECLARE		  @ApplicationName			varchar(50)
				, @EnvironmentName			varchar(50)
				, @ExecutionInstanceGUID	uniqueidentifier
				, @ExecStartDT				datetime
				, @BatchStatus				varchar(50)
				, @BatchExecKey				int
				, @ExecStopDT				datetime
				, @BatchDuration			int
				, @DataPkgKey				int

	DECLARE	   @IgnoreRowCnt				bigint
			 , @InsertRowCnt				bigint
			 , @UpdateRowCnt				bigint
			 , @ExceptionRowCnt				bigint
			 , @ExtractRowCnt				bigint
			 , @InsertNewRowCnt				bigint
			 , @InsertInferredRowCnt		bigint
			 , @InsertSCD2RowCnt			bigint
			 , @UpdateInferredRowCnt		bigint
			 , @UpdateSCD1RowCnt			bigint
			 , @UpdateSCD2RowCnt			bigint
			 , @InitialRowCnt				bigint
			 , @FinalRowCnt					bigint


	DECLARE		  @TableName			varchar(150)	-- Name of table
				, @CETTimeIncrement		int = 1
				, @CETTimeIncrementUnit	varchar(10) = 'DAY'
				, @LSET					datetime = NULL		-- Last Successful Extraction Time
				, @CET					datetime = NULL		-- Current Extraction Time

 	SET @TableName = N'[bi_cms_dds].[DimAccumulator]'

	SET @ApplicationName = 'HC_BI_CMS_UnitTest'
	SET @EnvironmentName = 'DEV'
	SET @ExecutionInstanceGUID = '{00000000-0000-0000-0000-000000000000}'
	SET @DataPkgKey = -1


	BEGIN TRY


		-- Get the Last Successful Extraction Time and Current Extraction Time
		EXEC	@return_value = [bief_stage].[_DataFlow_GetExtractionTime] @CETTimeIncrement, @CETTimeIncrementUnit, @TableName, @LSET OUTPUT, @CET OUTPUT

PRINT @LSET
PRINT @CET

		-- Get the BatchKey
		SET @ExecStartDT = GETDATE()
		SET @BatchStatus = 'Active'
		EXEC	@return_value = [bief_stage].[sp_META_AuditBatchExecution_Insert] @ApplicationName, @EnvironmentName, @ExecutionInstanceGUID, @ExecStartDT, @BatchStatus, @BatchExecKey OUTPUT



		-- Get DataPkgKey so it can be passed on to our execution packages
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkg_GetDataPkgForExtraction] @BatchExecKey, @ExecStartDT, @DataPkgKey OUTPUT

		-- Extract the data and place in STAGE
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulator_Extract] @DataPkgKey, @LSET, @CET

		-- Transform the data
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulator_Transform] @DataPkgKey

		-- Validate the data
		EXEC	@return_value = [bi_cms_stage].[spHC_DQA_DimAccumulator] @DataPkgKey

		-- Load the data into DDS
		EXEC	@return_value = [bi_cms_stage].[spHC_DDS_DimAccumulator_Upsert] @DataPkgKey
					 , @IgnoreRowCnt				 output
					 , @InsertRowCnt				 output
					 , @UpdateRowCnt				 output
					 , @ExceptionRowCnt				 output
					 , @ExtractRowCnt				 output
					 , @InsertNewRowCnt				 output
					 , @InsertInferredRowCnt		 output
					 , @InsertSCD2RowCnt			 output
					 , @UpdateInferredRowCnt		 output
					 , @UpdateSCD1RowCnt			 output
					 , @UpdateSCD2RowCnt			 output
					 , @InitialRowCnt				 output
					 , @FinalRowCnt					 output

		-- Cleanup the data in STAGE
		EXEC	@return_value = [bi_cms_stage].[spHC_DimAccumulator_Cleanup] @DataPkgKey

		-- Close the DataPkg
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkg_MarkDataPkgLoadComplete] @DataPkgKey




		-- Write the duration info
		SET @BatchStatus = 'Complete'
		SET @ExecStopDT = GETDATE()
		SET @BatchDuration = DATEDIFF(second,@ExecStartDT,@ExecStopDT)
		EXEC	@return_value = [bief_stage].[sp_META_AuditBatchExecution_Close] @BatchExecKey, @ExecStopDT, @BatchDuration, @BatchStatus

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

		-- Close the DataPkg
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkg_MarkDataPkgLoadFailure] @DataPkgKey

		SET @BatchStatus = 'Failed'
		SET @ExecStopDT = GETDATE()
		SET @BatchDuration = DATEDIFF(second,@ExecStartDT,@ExecStopDT)
		EXEC	@return_value = [bief_stage].[sp_META_AuditBatchExecution_Close] @BatchExecKey, @ExecStopDT, @BatchDuration, @BatchStatus


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
