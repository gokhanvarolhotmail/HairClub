/* CreateDate: 05/03/2010 12:26:23.080 , ModifyDate: 05/03/2010 12:26:23.080 */
GO
CREATE PROCEDURE [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop]
			  @DataPkgKey				int
			, @TableName				varchar(150) = NULL
			, @IgnoreRowCnt				bigint = NULL
			, @InsertRowCnt				bigint = NULL
			, @UpdateRowCnt				bigint = NULL
			, @ExceptionRowCnt			bigint = NULL
			, @ExtractRowCnt			bigint = NULL
			, @InsertNewRowCnt			bigint = NULL
			, @InsertInferredRowCnt		bigint = NULL
			, @InsertSCD2RowCnt			bigint = NULL
			, @UpdateInferredRowCnt		bigint = NULL
			, @UpdateSCD1RowCnt			bigint = NULL
			, @UpdateSCD2RowCnt			bigint = NULL
			, @InitialRowCnt			bigint = NULL
			, @FinalRowCnt				bigint = NULL
			, @DeletedRowCnt			bigint = NULL
			, @DuplicateRowCnt			bigint = NULL
			, @HealthyRowCnt			bigint = NULL
			, @RejectedRowCnt			bigint = NULL
			, @AllowedRowCnt			bigint = NULL
			, @FixedRowCnt				bigint = NULL

AS
-------------------------------------------------------------------------
-- [sp_META_AuditDataPkgDetail_LoadStop] is used to record end time of  the
-- data pkg detail record
--
--
--   exec [[bief_stage]].[sp_META_AuditDataPkgDetail_LoadStop] 1,
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
				, DeletedRowCnt = @DeletedRowCnt
				, DuplicateRowCnt = @DuplicateRowCnt
				, HealthyRowCnt = @HealthyRowCnt
				, RejectedRowCnt = @RejectedRowCnt
				, AllowedRowCnt = @AllowedRowCnt
				, FixedRowCnt = @FixedRowCnt

  				, [Status]= 'Load Complete'
				, [StatusDT] = GETDATE()
		WHERE [TableName] = @TableName
		AND		[DataPkgKey] = @DataPkgKey


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
