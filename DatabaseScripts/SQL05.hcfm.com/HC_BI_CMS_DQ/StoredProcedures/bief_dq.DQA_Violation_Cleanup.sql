/* CreateDate: 05/03/2010 12:19:15.350 , ModifyDate: 05/03/2010 12:19:15.350 */
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



		-- Remove records from [DimAccumulator] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimAccumulator]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimAccumulatorActionType] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimAccumulatorActionType]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END





		-- Remove records from [DimClient] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimClient]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimClientMembership] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimClientMembership]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimMembership] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimMembership]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END




		-- Remove records from [DimSalesCode] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesCode]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END




		-- Remove records from [DimEmployee] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimEmployee]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimSalesCodeDepartment] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesCodeDepartment]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimSalesCodeDivision] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesCodeDivision]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimSalesOrder] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesOrder]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimSalesOrderDetail] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesOrderDetail]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimSalesOrderTender] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesOrderTender]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimSalesOrderType] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimSalesOrderType]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimTenderType] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[DimTenderType]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END



		-- Remove records from [FactSales] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[FactSales]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [FactSalesTransaction] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[FactSalesTransaction]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [FactSalesTransactionTender] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_cms_dqa].[FactSalesTransactionTender]
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
