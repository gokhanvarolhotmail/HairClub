/* CreateDate: 05/03/2010 12:09:44.663 , ModifyDate: 03/26/2018 15:52:56.853 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimBusinessUnit_Truncate]


AS
-------------------------------------------------------------------------
-- [spHC_DimBusinessUnit_Truncate] is used to cleanup table
-- before loading.
--
--
--   exec [bi_ent_stage].[spHC_DimBusinessUnit_Truncate]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			03/26/2018  KMurdoch	 commented out code
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters

 /*
	BEGIN TRY


		TRUNCATE TABLE [bi_ent_stage].[DimBusinessUnit]

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

	*/
END
GO
