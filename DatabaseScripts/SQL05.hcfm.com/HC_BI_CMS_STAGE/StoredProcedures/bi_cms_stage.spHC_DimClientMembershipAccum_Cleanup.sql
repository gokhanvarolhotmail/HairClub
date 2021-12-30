/* CreateDate: 10/05/2010 14:04:33.960 , ModifyDate: 10/05/2010 14:04:33.960 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembershipAccum_Cleanup]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembershipAccum_Cleanup] is used to Cleanup records
--
--
--   exec [bi_cms_stage].[spHC_DimClientMembershipAccum_Cleanup] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembershipAccum]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_CleanupStart] @DataPkgKey, @TableName

		-----------------------
		-- Remove loaded records
		-----------------------
		DELETE FROM [bi_cms_stage].[DimClientMembershipAccum]
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
