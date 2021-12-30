/* CreateDate: 05/03/2010 12:09:21.637 , ModifyDate: 05/03/2010 12:09:21.637 */
GO
CREATE PROCEDURE [bief_meta].[META_AuditBatchExecution_Insert]
			  @ApplicationName			varchar(50) = NULL
			, @EnvironmentName			varchar(50) = NULL
			, @ExecutionInstanceGUID	uniqueidentifier = NULL
			, @ExecStartDT				datetime = NULL
			, @BatchStatus				varchar(50) = NULL
			, @BatchExecKey				int output
AS
-------------------------------------------------------------------------
-- [META_AuditBatchExecution_Insert] is used to log batch number
-- of the SSIS execution
--
--
--   exec [bief_meta].[META_AuditBatchExecution_Insert] 'Roche AccuCheck DW', 'DEV'
--             , '{4a57f328-f98c-4f2e-b912-e1f37fdd8d09}'
--             , '8/6/2008 7:42:47 PM', 'Active', @BatchExecKey
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
		EXEC [bief_meta]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'ApplicationName'
				, @ApplicationName
				, N'EnvironmentName'
				, @EnvironmentName
				, N'ExecutionInstanceGUID'
				, @ExecutionInstanceGUID
				, N'ExecStartDT'
				, @ExecStartDT
				, N'BatchStatus'
				, @BatchStatus


		INSERT INTO [bief_meta].[AuditBatchExecution]
				   ([ApplicationName]
				   ,[EnvironmentName]
				   ,[ExecutionInstanceGUID]
				   ,[ExecStartDT]
				   ,[Status]
				   ,[StatusDT]
				   )
			 VALUES
				   (@ApplicationName
				   ,@EnvironmentName
				   ,@ExecutionInstanceGUID
				   ,@ExecStartDT
				   ,@BatchStatus
				   ,GETDATE()
				   )

		SET @BatchExecKey = scope_identity()

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
		EXECUTE [bief_meta].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;

		-- Re Raise the error
		EXECUTE [bief_meta].[_DBErrorLog_RethrowError] @vchTagValueList;

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF
		-- Cleanup temp tables

		-- Return the error number
		RETURN @intError;
    END CATCH


END
GO
