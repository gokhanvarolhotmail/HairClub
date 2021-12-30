/* CreateDate: 05/03/2010 12:09:07.050 , ModifyDate: 05/12/2010 12:25:50.673 */
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





		-- Remove records from [DimBusinessSegment] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimBusinessSegment]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimBusinessUnit] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimBusinessUnit]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimBusinessUnitBrand] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimBusinessUnitBrand]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimCenter] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimCenter]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimCenterOwnership] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimCenterOwnership]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimCenterType] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimCenterType]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END




		-- Remove records from [DimRevenueGroup] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimRevenueGroup]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END



		-- Remove records from [DimDoctorRegion] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimDoctorRegion]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Remove records from [DimGeography] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimGeography]
				WHERE [CreateTimestamp] < @ArchiveDate

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END

		-- Remove records from [DimTimeZone] table
		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM  [bi_ent_dqa].[DimTimeZone]
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
