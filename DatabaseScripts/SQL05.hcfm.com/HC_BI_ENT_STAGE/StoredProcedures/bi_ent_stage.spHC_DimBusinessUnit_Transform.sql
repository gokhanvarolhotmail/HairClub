/* CreateDate: 05/03/2010 12:09:44.620 , ModifyDate: 03/26/2018 15:51:17.230 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimBusinessUnit_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimBusinessUnit_Transform] is used to transform records
--
--
--   exec [bi_ent_stage].[spHC_DimBusinessUnit_Transform] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
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
 				, @return_value		int

	DECLARE		  @TableName			varchar(150)	-- Name of table

 	SET @TableName = N'[bi_ent_dds].[DimBusinessUnit]'
/*

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName

		-----------------------
		-- Transform BusinessUnitBrandKey
		-----------------------
		EXEC	@return_value = [bi_ent_stage].[spHC_DimBusinessUnit_Transform_BusinessUnitBrandKey] @DataPkgKey

		-----------------------
		-- Set the ISNew and SCD fields
		-----------------------
		EXEC	@return_value = [bi_ent_stage].[spHC_DimBusinessUnit_Transform_SetIsNewSCD] @DataPkgKey


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStop] @DataPkgKey, @TableName

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