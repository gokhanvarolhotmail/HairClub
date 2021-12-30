/* CreateDate: 05/03/2010 12:22:45.017 , ModifyDate: 05/12/2010 12:30:45.570 */
GO
CREATE PROCEDURE [bief_dq].[DQA_Violation_Cleanup]
			  @NumDaysToKeep			int = 7
AS
-------------------------------------------------------------------------
-- [DQA_Violation_Cleanup] is used to cleanup old violations and records
-- from Dim & Fact specific tables
--
--
--   exec [bief_dq].[DQA_Violation_Cleanup] 5
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

     DECLARE	 @CleanupRowCnt	int
			    , @RowsProcessed	int
				, @BatchSize		int


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_dq]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@NumDaysToKeep'
				, @NumDaysToKeep

		-- Get BatchSize from _DBConfig table
		SET @BatchSize = 100000
		SET @CleanupRowCnt = 0

		IF (@NumDaysToKeep < 0) SET @NumDaysToKeep = 7

		DECLARE @ArchiveDate datetime
		SET @ArchiveDate = DATEADD(d,-@NumDaysToKeep,GETDATE())



		-- Remove records from [DimActionCode] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimActionCode]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimActivity] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimActivity]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimActivityDemographic] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimActivityDemographic]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimActivityResult] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimActivityResult]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END





		-- Remove records from [DimContact] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimContact]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimContactAddress] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimContactAddress]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimContactEmail] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimContactEmail]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimContactPhone] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimContactPhone]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimContactSource] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimContactSource]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END



		-- Remove records from [DimEmployee] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimEmployee]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimResultCode] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimResultCode]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimSalesType] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimSalesType]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimSource] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[DimSource]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [FactActivity] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[FactActivity]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [FactActivityResults] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[FactActivityResults]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [FactLead] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_mktg_dqa].[FactLead]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END




		-- Remove records from [Violation] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM [bief_dq].[Violation]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
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
		EXECUTE [bief_dq].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;

		-- Re Raise the error
		EXECUTE [bief_dq].[_DBErrorLog_RethrowError] @vchTagValueList;

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF
		-- Cleanup temp tables

		-- Return the error number
		RETURN @intError;
    END CATCH


END
GO
