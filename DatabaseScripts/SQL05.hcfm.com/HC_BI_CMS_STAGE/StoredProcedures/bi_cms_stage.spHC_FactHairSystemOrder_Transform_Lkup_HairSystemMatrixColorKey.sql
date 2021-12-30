/* CreateDate: 06/27/2011 17:23:47.767 , ModifyDate: 10/26/2011 11:21:03.537 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemMatrixColorKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Transform_Lkup_HairSystemMatrixColorKey] is used to determine
-- the HairSystemMatrixColorKey foreign key values in the FactHairSystemOrder table using DimHairSystemMatrixColor.
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
--			10/26/2011  KMurdoch	 Added Exception Message
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
		       [HairSystemMatrixColorKey]  = -1
		     , [HairSystemMatrixColorSSID] = -2
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[HairSystemMatrixColorSSID]) <> 1)


		------------------------
		-- There might be some other load that just added them
		-- Update [HairSystemMatrixColorKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [HairSystemMatrixColorKey] = COALESCE(DW.[HairSystemMatrixColorKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemMatrixColor] DW  WITH (NOLOCK)
			ON DW.[HairSystemMatrixColorSSID] = STG.[HairSystemMatrixColorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.HairSystemMatrixColorKey, 0) = 0
			AND STG.[HairSystemMatrixColorSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_LoadInferred_DimHairSystemMatrixColor] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [HairSystemMatrixColorKey] = COALESCE(DW.[HairSystemMatrixColorKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemMatrixColor] DW  WITH (NOLOCK)
			ON DW.[HairSystemMatrixColorSSID] = STG.[HairSystemMatrixColorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[HairSystemMatrixColorKey], 0) = 0
			AND STG.[HairSystemMatrixColorSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [HairSystemMatrixColorKey]
		---------------------------
		----UPDATE STG SET
		----     [HairSystemMatrixColorKey] = -1
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[HairSystemMatrixColorKey] IS NULL

		---------------------------
		------ Fix [HairSystemMatrixColorSSID]
		---------------------------
		----UPDATE STG SET
		----       [HairSystemMatrixColorKey]  = -1
		----     , [HairSystemMatrixColorSSID] = -2
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[HairSystemMatrixColorSSID] IS NULL )

		-----------------------
		-- Exception if [HairSystemMatrixColorSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemMatrixColorSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairSystemMatrixColorSSID] IS NULL


		-----------------------
		-- Exception if [HairSystemMatrixColorKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemMatrixColorKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairSystemMatrixColorKey] IS NULL
				OR STG.[HairSystemMatrixColorKey] = 0)


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
