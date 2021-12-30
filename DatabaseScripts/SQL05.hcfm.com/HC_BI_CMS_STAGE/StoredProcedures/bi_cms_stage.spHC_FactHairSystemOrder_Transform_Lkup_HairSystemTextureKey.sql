/* CreateDate: 06/27/2011 17:23:47.693 , ModifyDate: 10/26/2011 11:24:30.403 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTextureKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTextureKey] is used to determine
-- the HairSystemTextureKey foreign key values in the FactHairSystemOrder table using DimHairSystemTexture.
--
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_CenterKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  MBurrell     Initial Creation
--			10/26/2011  KMurdoch     Added Exception Message
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


 	-- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		-----------------------
		-- Found an instance where the center number was not numeric
		-- so fix this first
		-----------------------
		UPDATE STG SET
		       [HairSystemTextureKey]  = -1
		     , [HairSystemTextureSSID] = -2
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[HairSystemTextureSSID]) <> 1)


		------------------------
		-- There might be some other load that just added them
		-- Update [HairSystemTextureKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [HairSystemTextureKey] = COALESCE(DW.[HairSystemTextureKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemTexture] DW  WITH (NOLOCK)
			ON DW.[HairSystemTextureSSID] = STG.[HairSystemTextureSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.HairSystemTextureKey, 0) = 0
			AND STG.[HairSystemTextureSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_LoadInferred_DimHairSystemTexture] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [HairSystemTextureKey] = COALESCE(DW.[HairSystemTextureKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemTexture] DW  WITH (NOLOCK)
			ON DW.HairSystemTextureSSID = STG.HairSystemTextureSSID
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.HairSystemTextureKey, 0) = 0
			AND STG.[HairSystemTextureSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [HairSystemTextureKey]
		---------------------------
		----UPDATE STG SET
		----     [HairSystemTextureKey] = -1
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[HairSystemTextureKey] IS NULL

		---------------------------
		------ Fix [HairSystemTextureSSID]
		---------------------------
		----UPDATE STG SET
		----       [HairSystemTextureKey]  = -1
		----     , [HairSystemTextureSSID] = -2
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[HairSystemTextureSSID] IS NULL )

		-----------------------
		-- Exception if [HairSystemTextureSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemTextureSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairSystemTextureSSID] IS NULL


		-----------------------
		-- Exception if [HairSystemTextureKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemTextureKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.HairSystemTextureKey IS NULL
				OR STG.[HairSystemTextureKey] = 0)


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
