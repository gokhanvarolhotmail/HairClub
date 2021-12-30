/* CreateDate: 05/03/2010 12:09:21.820 , ModifyDate: 05/03/2010 12:09:21.820 */
GO
CREATE PROCEDURE [bief_meta].[META_AuditDataPkg_MarkDataPkgValidationFailure]
			 @DataPkgKey				int
AS
-------------------------------------------------------------------------
-- [META_AuditDataPkg_MarkDataPkgValidationFailure] is used to update
--            status of Data Package
--
--
--
--   exec [bief_meta].[META_AuditDataPkg_MarkDataPkgValidationFailure] 23
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
				, N'@DataPkgKey'
				, @DataPkgKey


		UPDATE [bief_meta].[AuditDataPkg]
				SET [Status] = 'Validation Failure'
				, [StatusDT] = GETDATE()
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
