/* CreateDate: 06/27/2011 17:23:51.760 , ModifyDate: 07/06/2011 14:16:56.200 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Transform] is used to transform records
--
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Transform] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  MBurrell     Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName

		-----------------------
		-- Lookup the foreign keys for the dimensions on the fact table
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_DateKeys] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_CenterKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_ClientKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_ClientMembershipKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemHairLengthKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTypeKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTextureKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemMatrixColorKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemDensityKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemFrontalDensityKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemStyleKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemDesignTemplateKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemRecessionKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTopHairColorKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_MeasurementsByEmployeeKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemVendorContractKey] @DataPkgKey

		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemOrderStatusKey] @DataPkgKey


		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_SetIsNewUpdDel] @DataPkgKey


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


END
GO
