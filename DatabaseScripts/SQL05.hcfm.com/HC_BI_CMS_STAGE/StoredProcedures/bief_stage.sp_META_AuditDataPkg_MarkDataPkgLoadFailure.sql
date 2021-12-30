/* CreateDate: 10/05/2010 14:04:30.797 , ModifyDate: 10/05/2010 14:04:30.797 */
GO
CREATE PROCEDURE [bief_stage].[sp_META_AuditDataPkg_MarkDataPkgLoadFailure]
			 @DataPkgKey				int
AS
-------------------------------------------------------------------------
-- [sp_META_AuditDataPkg_MarkDataPkgLoadFailure] is used to update
--            status of Data Package
--
--
--
--   exec [bief_stage].[sp_META_AuditDataPkg_MarkDataPkgLoadFailure] 23
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
				, N'@DataPkgKey'
				, @DataPkgKey


		UPDATE [bief_stage].[syn_META_AuditDataPkg]
				SET [Status] = 'Load Failure'
				, [StatusDT] = GETDATE()
				, [ExecStopDT] = GETDATE()
		WHERE DataPkgKey = @DataPkgKey



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
