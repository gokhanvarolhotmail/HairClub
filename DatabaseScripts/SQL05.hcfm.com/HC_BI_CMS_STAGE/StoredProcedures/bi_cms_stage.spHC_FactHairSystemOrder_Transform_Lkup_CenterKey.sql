/* CreateDate: 06/27/2011 17:23:51.743 , ModifyDate: 11/06/2012 13:28:38.557 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_CenterKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactHairSystemOrder_Transform_Lkup_CenterKey] is used to determine
-- the CenterKey foreign key values in the FactHairSystemOrder table using DimCenter.
--
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_CenterKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch     Initial Creation
--			10/26/2011	KMurdoch	 Added Exception Message
--			11/06/2012  KMurdoch	 Added in ClientHomeCenter derivation
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
		--CenterID
		UPDATE STG SET
		       [CenterKey]  = -1
		     , [CenterSSID] = -2
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[CenterSSID]) <> 1)

		--ClientHomeCenterID
		UPDATE STG SET
		       [ClientHomeCenterKey]  = -1
		     , [ClientHomeCenterSSID] = -2
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[ClientHomeCenterSSID]) <> 1)

		------------------------
		-- There might be some other load that just added them
		-- Update [CenterKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [CenterKey] = COALESCE(DW.[CenterKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW  WITH (NOLOCK)
			ON DW.[CenterSSID] = STG.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CenterKey], 0) = 0
			AND STG.[CenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		--ClientHomeCenterID
		UPDATE STG SET
		     [ClientHomeCenterKey] = COALESCE(DW.[CenterKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW  WITH (NOLOCK)
			ON DW.[CenterSSID] = STG.[ClientHomeCenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientHomeCenterKey], 0) = 0
			AND STG.[ClientHomeCenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_LoadInferred_DimCenter] @DataPkgKey


		-- Update Center Keys in STG

		UPDATE STG SET
		     [CenterKey] = COALESCE(DW.[CenterKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW  WITH (NOLOCK)
			ON DW.[CenterSSID] = STG.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CenterKey], 0) = 0
			AND STG.[CenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Update ClientHomeCenter Keys in STG
		UPDATE STG SET
		     [ClientHomeCenterKey] = COALESCE(DW.[CenterKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW  WITH (NOLOCK)
			ON DW.[CenterSSID] = STG.[ClientHomeCenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientHomeCenterKey], 0) = 0
			AND STG.[ClientHomeCenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [CenterKey]
		---------------------------
		----UPDATE STG SET
		----     [CenterKey] = -1
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[CenterKey] IS NULL

		---------------------------
		------ Fix [CenterSSID]
		---------------------------
		----UPDATE STG SET
		----       [CenterKey]  = -1
		----     , [CenterSSID] = -2
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[CenterSSID] IS NULL )

		-----------------------
		-- Exception if [CenterSSID] or [ClientHomeCenterSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'CenterSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterSSID] IS NULL

		-- Update ClientHomeCenter Keys in STG
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'CenterSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientHomeCenterSSID] IS NULL


		-----------------------
		-- Exception if [CenterKey] or [ClientHomeCenterKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'CenterKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterKey] IS NULL
				OR STG.[CenterKey] = 0)

		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientHomeCenterKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientHomeCenterKey] IS NULL
				OR STG.[ClientHomeCenterKey] = 0)


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
