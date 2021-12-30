/* CreateDate: 06/27/2011 17:23:47.677 , ModifyDate: 10/26/2011 11:25:16.753 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTopHairColorKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Transform_Lkup_HairSystemTopHairColorKey] is used to determine
-- the HairSystemTopHairColorKey foreign key values in the FactHairSystemOrder table using DimHairSystemHairColor.
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
		       [HairSystemTopHairColorKey]  = -1
		     , [HairSystemTopHairColorSSID] = -2
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[HairSystemTopHairColorSSID]) <> 1)


		------------------------
		-- There might be some other load that just added them
		-- Update [HairSystemTopHairColorKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [HairSystemTopHairColorKey] = COALESCE(DW.[HairSystemHairColorKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemHairColor] DW  WITH (NOLOCK)
			ON DW.[HairSystemHairColorSSID] = STG.[HairSystemTopHairColorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.HairSystemTopHairColorKey, 0) = 0
			AND STG.[HairSystemTopHairColorSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_LoadInferred_DimHairSystemHairColor] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [HairSystemTopHairColorKey] = COALESCE(DW.[HairSystemHairColorKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemHairColor] DW  WITH (NOLOCK)
			ON DW.[HairSystemHairColorSSID] = STG.[HairSystemTopHairColorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[HairSystemTopHairColorKey], 0) = 0
			AND STG.[HairSystemTopHairColorSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [HairSystemTopHairColorKey]
		---------------------------
		----UPDATE STG SET
		----     [HairSystemTopHairColorKey] = -1
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[HairSystemTopHairColorKey] IS NULL

		---------------------------
		------ Fix [HairSystemTopHairColorSSID]
		---------------------------
		----UPDATE STG SET
		----       [HairSystemTopHairColorKey]  = -1
		----     , [HairSystemTopHairColorSSID] = -2
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[HairSystemTopHairColorSSID] IS NULL )

		-----------------------
		-- Exception if [HairSystemTopHairColorSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemTopHairColorSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairSystemTopHairColorSSID] IS NULL


		-----------------------
		-- Exception if [HairSystemTopHairColorKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemTopHairColorKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairSystemTopHairColorKey] IS NULL
				OR STG.[HairSystemTopHairColorKey] = 0)


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
