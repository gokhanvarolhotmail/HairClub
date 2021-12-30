/* CreateDate: 05/03/2010 12:19:28.223 , ModifyDate: 06/07/2011 13:26:41.177 */
GO
CREATE PROCEDURE [bief_meta].[META_AuditDataPkg_GetDataPkgForExtraction]
			  @BatchExecKey				int
			, @ExecStartDT				datetime = NULL
			, @DataPkgProcess                  varchar(50) = NULL
			, @DataPkgKey				int output
AS
-------------------------------------------------------------------------
-- [META_AuditDataPkg_GetDataPkgForExtraction] is used to log Data Package ID
--
--
--
--   exec [bief_meta].[META_AuditDataPkg_GetDataPkgForExtraction] 23,
--             , '8/6/2008 7:42:47 PM', @DataPkgKey
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  3.0	    05/16/2011	EKnapp		  Add 'DataPkgProcess' parameter.
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
				, N'@BatchExecKey'
				, @BatchExecKey
				, N'@ExecStartDT'
				, @ExecStartDT


		INSERT INTO [bief_meta].[AuditDataPkg]
				   ([BatchExecKey]
				   ,[Process]
				   ,[ExecStartDT]
				   ,[Status]
				   ,[StatusDT]
				   )
			 VALUES
				   (@BatchExecKey
				   ,@DataPkgProcess
				   ,@ExecStartDT
				   ,'Data Package Created'
				   ,GETDATE()
				   )

		SET @DataPkgKey = scope_identity()

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
