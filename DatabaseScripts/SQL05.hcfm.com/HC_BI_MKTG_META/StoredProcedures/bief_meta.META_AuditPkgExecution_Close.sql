/* CreateDate: 05/03/2010 12:23:09.360 , ModifyDate: 05/03/2010 12:23:09.360 */
GO
CREATE PROCEDURE [bief_meta].[META_AuditPkgExecution_Close]
			  @PkgExecKey				int
			, @ExecStopDT				datetime = NULL
			, @PkgDuration				int
			, @PkgStatus				varchar(50) = NULL
AS
-------------------------------------------------------------------------
-- [META_AuditPkgExecution_Close] is used to close the status and
-- Stop Date Time of the SSIS execution
--
--
--   exec [bief_meta].[META_AuditPkgExecution_Close] 1, '8/6/2008 7:42:47 PM', 23, 'Failed'
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
				, N'PkgExecKey'
				, @PkgExecKey
				, N'ExecStopDT'
				, @ExecStopDT
				, N'PkgDuration'
				, @PkgDuration
				, N'PkgStatus'
				, @PkgStatus

		UPDATE [bief_meta].[AuditPkgExecution]
				SET [ExecStopDT] = @ExecStopDT
				, [PkgDuration] = @PkgDuration
				, [Status] = @PkgStatus
				, [StatusDT] = GETDATE()
		WHERE PkgExecKey = @PkgExecKey

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
