/* CreateDate: 10/05/2010 14:04:30.677 , ModifyDate: 10/05/2010 14:04:30.677 */
GO
CREATE PROCEDURE [bief_stage].[sp_META_AuditBatchExecution_Close]
			  @BatchExecKey				int
			, @ExecStopDT				datetime = NULL
			, @BatchDuration			int
			, @BatchStatus				varchar(50) = NULL
AS
-------------------------------------------------------------------------
-- [sp_META_AuditBatchExecution_Close] is used to close the record
-- recording status and Stop Date Time
--
--
--   exec [bief_stage].[sp_META_AuditBatchExecution_Close] 1, '8/6/2008 7:42:47 PM', 23, 'Failed'
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


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'BatchExecKey'
				, @BatchExecKey
				, N'ExecStopDT'
				, @ExecStopDT
				, N'BatchDuration'
				, @BatchDuration
				, N'BatchStatus'
				, @BatchStatus



		UPDATE [bief_stage].[syn_META_AuditBatchExecution]
				SET [ExecStopDT] = @ExecStopDT
				, [BatchDuration] = @BatchDuration
				, [Status] = @BatchStatus
				, [StatusDT] = GETDATE()
		WHERE [BatchExecKey] = @BatchExecKey

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
