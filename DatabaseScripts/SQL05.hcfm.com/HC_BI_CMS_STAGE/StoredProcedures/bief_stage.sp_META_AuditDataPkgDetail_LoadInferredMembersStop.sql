/* CreateDate: 05/03/2010 12:19:46.897 , ModifyDate: 05/03/2010 12:19:46.897 */
GO
CREATE PROCEDURE [bief_stage].[sp_META_AuditDataPkgDetail_LoadInferredMembersStop]
			  @DataPkgKey				int
			, @TableName				varchar(150) = NULL
			, @DataPkgDetailKey			int
			, @IgnoreRowCnt				bigint  = NULL
			, @InsertRowCnt				bigint  = NULL
			, @UpdateRowCnt				bigint  = NULL
			, @ExceptionRowCnt			bigint  = NULL
			, @ExtractRowCnt			bigint  = NULL
			, @InsertNewRowCnt			bigint  = NULL
			, @InsertInferredRowCnt		bigint = NULL
			, @InsertSCD2RowCnt			bigint = NULL
			, @UpdateInferredRowCnt		bigint  = NULL
			, @UpdateSCD1RowCnt			bigint = NULL
			, @UpdateSCD2RowCnt			bigint = NULL
			, @InitialRowCnt			bigint = NULL
			, @FinalRowCnt				bigint = NULL

AS
-------------------------------------------------------------------------
-- [[sp_META_AuditDataPkgDetail_LoadInferredMembersStop]] is used to record
-- end time of  the
-- data pkg detail record
--
--
--   exec [[bief_stage]].[sp_META_AuditDataPkgDetail_LoadInferredMembersStop] 1,
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


		UPDATE [bief_stage].[syn_META_AuditDataPkgDetail]
                SET [IsLoaded] = 1
                , [LoadStopDT] = GETDATE()
 				, IgnoreRowCnt = @IgnoreRowCnt
				, InsertRowCnt = @InsertRowCnt
				, UpdateRowCnt = @UpdateRowCnt
				, InsertNewRowCnt = @InsertNewRowCnt
				, InsertInferredRowCnt = @InsertInferredRowCnt
				, InsertSCD2RowCnt = @InsertSCD2RowCnt
				, UpdateInferredRowCnt = @UpdateInferredRowCnt
				, UpdateSCD1RowCnt = @UpdateSCD1RowCnt
				, UpdateSCD2RowCnt = @UpdateSCD2RowCnt
				, ExceptionRowCnt = @ExceptionRowCnt
 				, TableInitialRowCnt = @InitialRowCnt
				, TableFinalRowCnt = @FinalRowCnt
 				, [Status]= 'Load Inferred Members Complete'
				, [StatusDT] = GETDATE()
		WHERE [TableName] = @TableName
		AND		[DataPkgKey] = @DataPkgKey
		AND		[DataPkgDetailKey] = @DataPkgDetailKey


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
