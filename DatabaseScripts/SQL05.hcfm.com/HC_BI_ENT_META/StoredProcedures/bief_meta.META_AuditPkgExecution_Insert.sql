/* CreateDate: 05/03/2010 12:09:21.850 , ModifyDate: 05/03/2010 12:09:21.850 */
GO
CREATE PROCEDURE [bief_meta].[META_AuditPkgExecution_Insert]
			  @ParentPkgExecKey			int = -1
			, @BatchExecKey				int = -1
			, @ExecutionInstanceGUID	uniqueidentifier = NULL
			, @PkgName					varchar(50) = NULL
			, @PkgGUID					uniqueidentifier = NULL
			, @PkgVersionGUID			uniqueidentifier = NULL
			, @PkgVersionMajor			smallint = -1
			, @PkgVersionMinor			smallint = -1
			, @ExecStartDT				datetime = NULL
			, @PkgStatus				varchar(50) = NULL
			, @PkgExecKey				int output
AS
-------------------------------------------------------------------------
-- [META_AuditPkgExecution_Insert] is used to log batch number
-- of the SSIS execution
--
--
--   exec [bief_meta].[META_AuditPkgExecution_Insert] -1, -1
--             ,'{4a57f328-f98c-4f2e-b912-e1f37fdd8d09}'
--             ,'Pkg Name'
--             ,'{4a57f328-f98c-4f2e-b912-e1f37fdd8d09}'
--				,'{4a57f328-f98c-4f2e-b912-e1f37fdd8d09}'
--				,1, 0, '8/6/2008 7:42:47 PM', 'Active', @PkgExecKey
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
				, N'@ParentPkgExecKey'
				, @ParentPkgExecKey
				, N'@BatchExecKey'
				, @BatchExecKey
				, N'@ExecutionInstanceGUID'
				, @ExecutionInstanceGUID
				, N'@PkgName'
				, @PkgName
				, N'@PkgGUID'
				, @PkgGUID
				, N'@PkgVersionGUID'
				, @PkgVersionGUID
				, N'@PkgVersionMajor'
				, @PkgVersionMajor
				, N'@PkgVersionMinor'
				, @PkgVersionMinor
				, N'PkgExecKey'
				, @PkgExecKey
				, N'@ExecStartDT'
				, @ExecStartDT
				, N'PkgStatus'
				, @PkgStatus


		INSERT INTO [bief_meta].[AuditPkgExecution]
			   ([ParentPkgExecKey]
			   ,[BatchExecKey]
			   ,[ExecutionInstanceGUID]
			   ,[PkgName]
			   ,[PkgGUID]
			   ,[PkgVersionGUID]
			   ,[PkgVersionMajor]
			   ,[PkgVersionMinor]
			   ,[ExecStartDT]
			   ,[Status]
			   ,[StatusDT]
			   )
		 VALUES
			   (@ParentPkgExecKey
			   ,@BatchExecKey
			   ,@ExecutionInstanceGUID
			   ,@PkgName
			   ,@PkgGUID
			   ,@PkgVersionGUID
			   ,@PkgVersionMajor
			   ,@PkgVersionMinor
			   ,@ExecStartDT
			   ,@PkgStatus
			   ,GETDATE()
			   )

		SET @PkgExecKey = scope_identity()


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
