/* CreateDate: 06/27/2011 17:23:15.617 , ModifyDate: 06/27/2011 17:23:15.617 */
GO
create PROCEDURE [bi_cms_stage].[spHC_DimHairSystemMatrixColor_Cleanup]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimHairSystemMatrixColor_Cleanup] is used to Cleanup records
--
--
--   exec [bi_cms_stage].[spHC_DimHairSystemMatrixColor_Cleanup] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/10/2011  EKnapp       Initial Creation
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

	DECLARE		  @TableName			varchar(150)	-- Name of table
				, @CleanupRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemMatrixColor]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_CleanupStart] @DataPkgKey, @TableName

		-----------------------
		-- Remove loaded records
		-----------------------
		DELETE FROM [bi_cms_stage].[DimHairSystemMatrixColor]
			WHERE DataPkgKey = @DataPkgKey

		SET @CleanupRowCnt = @@ROWCOUNT

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
