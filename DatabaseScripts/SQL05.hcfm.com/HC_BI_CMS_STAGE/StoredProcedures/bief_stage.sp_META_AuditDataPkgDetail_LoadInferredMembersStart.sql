/* CreateDate: 05/03/2010 12:19:46.880 , ModifyDate: 05/03/2010 12:19:46.880 */
GO
CREATE PROCEDURE [bief_stage].[sp_META_AuditDataPkgDetail_LoadInferredMembersStart]
			  @DataPkgKey				int
			, @TableName				varchar(150) = NULL
			, @DataPkgDetailKey			int output
AS
-------------------------------------------------------------------------
-- [[sp_META_AuditDataPkgDetail_LoadInferredMembersStart]] is used to create the
-- data pkg detail record
--
--
--   exec [[bief_stage]].[sp_META_AuditDataPkgDetail_LoadInferredMembersStart] 1,
--                   '[bi_stage].[DimDate]'
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
				, N'@TableName'
				, @TableName

		INSERT INTO [bief_stage].[syn_META_AuditDataPkgDetail]
				   ([DataPkgKey]
				   ,[TableName]
				   ,[LoadStartDT]
				   ,[Status]
				   ,[StatusDT]
				   )
			 VALUES
				   (@DataPkgKey
				   ,@TableName
				   ,GETDATE()
				   ,'Load Inferred Members Started'
				   ,GETDATE()
				   )

		SET @DataPkgDetailKey = scope_identity()

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
