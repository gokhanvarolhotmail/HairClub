/* CreateDate: 06/27/2011 17:22:53.847 , ModifyDate: 06/27/2011 17:22:53.847 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Cleanup]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Cleanup] is used to Cleanup records
--
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Cleanup] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
 				, @return_value		int

	DECLARE		  @TableName		varchar(150)	-- Name of table
				, @CleanupRowCnt	int
			    , @RowsProcessed	int
				, @BatchSize		int

	-- Get BatchSize from _DBConfig table
	SET @BatchSize = (SELECT [bief_stage].[fn_GetBatchSize]())
    SET @CleanupRowCnt = 0

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_CleanupStart] @DataPkgKey, @TableName

		WHILE ( 0 = 0 )
			BEGIN
				DELETE TOP ( @BatchSize )
				FROM [bi_cms_stage].[FactHairSystemOrder]
				WHERE DataPkgKey = @DataPkgKey
				AND IsLoaded = 1
				AND IsException = 0

				SET @RowsProcessed = @@ROWCOUNT
				SET @CleanupRowCnt = @CleanupRowCnt + @RowsProcessed

				IF @RowsProcessed < @BatchSize BREAK;
			END


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_CleanupStop] @DataPkgKey, @TableName, @CleanupRowCnt

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
