/* CreateDate: 05/03/2010 12:23:09.227 , ModifyDate: 06/07/2011 13:27:13.397 */
GO
CREATE PROCEDURE [bief_meta].[META_AuditDataPkg_GetDataPkgForTransformation]
			 @DataPkgProcess            varchar(50) = null
			 ,@DataPkgKey				int output
AS
-------------------------------------------------------------------------
-- [META_AuditDataPkg_GetDataPkgForTransformation] is used to update
--            status of Data Package
--
--
--
--   exec [bief_meta].[META_AuditDataPkg_GetDataPkgForTransformation] 23
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  3.0	    05/16/2011	EKnapp		  Add '@DataPkgProcess' parameter.
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters

	DECLARE		  @StatusDT			datetime

	BEGIN TRY

		IF @DataPkgProcess IS NULL
			SET @DataPkgProcess = ''

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_meta]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey

		-- Find the next DataPkg to process
		SELECT TOP 1 @DataPkgKey = DataPkgKey
				, @StatusDT = [StatusDT]
		FROM [bief_meta].[AuditDataPkg]
		WHERE [Status] = 'Extraction Complete'
		AND ISNULL(Process,'')= @DataPkgProcess
		ORDER BY [ExecStartDT] ASC



		-- Update the DataPkg
		IF (@DataPkgKey IS NOT NULL)
			BEGIN
				UPDATE [bief_meta].[AuditDataPkg]
						SET [Status] = 'Transformation Started'
						, [StatusDT] = GETDATE()
				WHERE DataPkgKey = @DataPkgKey
				AND [StatusDT] = @StatusDT

				IF @@ROWCOUNT = 0
					BEGIN
						SET @DataPkgKey = -1
					END
			END
		ELSE
			BEGIN
				SET @DataPkgKey = -1
			END


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
