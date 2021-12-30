/* CreateDate: 05/03/2010 12:23:09.440 , ModifyDate: 05/03/2010 12:23:09.440 */
GO
CREATE PROCEDURE [bief_meta].[META_SSISErrorLog_Insert]
			  @EventType				varchar(20) = NULL
			, @PackageID				varchar(50) = NULL
			, @PackageName				varchar(50) = NULL
			, @ParentContainerGUID		varchar(50) = NULL
			, @SourceID					varchar(50) = NULL
			, @SourceName				varchar(255) = NULL
			, @SourceDescription		varchar(255) = NULL
			, @SourceParentGUID			varchar(50) = NULL
			, @EventCode				int = -1
			, @EventDescription			varchar(max) = NULL
			, @PackageDuration			int = -1
			, @Host						varchar(50) = NULL
			, @ExecutionInstanceGUID	varchar(50) = NULL
AS
-------------------------------------------------------------------------
-- [META_SSISErrorLog_Insert] is used to log errors to the ErrorLog
-- table
--
--
--   exec [bief_meta].[META_SSISErrorLog_Insert] 'OnError'
--				, '{4a57f328-f98c-4f2e-b912-e1f37fdd8d45}', 'BatchPackage_H'
--				, '{1EB4f328-f98c-4f2e-b912-e1f37fdd8d45}
--				, '{4a57f328-f98c-4f2e-b912-e1f37fdd8d09}', 'EPT DimAccount'
--				, 'Execute Package Task', -1073602338, 'Event Desc'
--				, '{1EB4f328-f98c-4f2e-b912-e1f37fd77d45}
--				, 120, 'M65', '{AAD2A5F3-B93F-4805-A6E2-9428C80D186D}'
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
				, N'@EventType'
				, @EventType
				, N'@PackageID'
				, @PackageID
				, N'@PackageName'
				, @PackageName
				, N'@ParentContainerGUID'
				, @ParentContainerGUID
				, N'@SourceID'
				, @SourceID
				, N'@SourceName'
				, @SourceName
				, N'@SourceDescription'
				, @SourceDescription
				, N'@SourceParentGUID'
				, @SourceParentGUID
				, N'@EventCode'
				, @EventCode
				, N'@EventDescription'
				, @EventDescription
				, N'@PackageDuration'
				, @PackageDuration
				, N'@Host'
				, @Host
				, N'@ExecutionInstanceGUID'
				, @ExecutionInstanceGUID



		INSERT INTO [bief_meta].[SSISErrorLog]
                        ( EventType
                        , PackageID
                        , PackageName
                        , ParentContainerGUID
                        , SourceID
                        , SourceName
                        , SourceDescription
                        , SourceParentGUID
                        , EventCode
                        , EventDescription
                        , PackageDuration
                        , Host
                        , ExecutionInstanceGUID
                        , LastUpdateDate
                        )
                   VALUES
                        ( @EventType
                        , @PackageID
                        , @PackageName
                        , @ParentContainerGUID
                        , @SourceID
                        , @SourceName
                        , @SourceDescription
                        , @SourceParentGUID
                        , @EventCode
                        , @EventDescription
                        , @PackageDuration
                        , @Host
                        , @ExecutionInstanceGUID
                        , GETDATE()
                        )
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
