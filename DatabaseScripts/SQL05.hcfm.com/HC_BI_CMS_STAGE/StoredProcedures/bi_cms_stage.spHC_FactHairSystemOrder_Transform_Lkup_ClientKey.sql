/* CreateDate: 06/27/2011 17:23:47.937 , ModifyDate: 10/26/2011 11:12:53.363 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_ClientKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactHairSystemOrder_Transform_Lkup_ClientKey] is used to determine
-- the ClientKey foreign key values in the FactHairSystemOrder table using DimClient.
--
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_ClientKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch     Initial Creation
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

		------------------------
		-- There might be some other load that just added them
		-- Update [ClientKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ClientKey] = COALESCE(DW.[ClientKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW  WITH (NOLOCK)
			ON DW.[ClientSSID] = STG.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientKey], 0) = 0
			AND STG.[ClientSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_LoadInferred_DimClient] @DataPkgKey


		-- Update Client Keys in STG
		UPDATE STG SET
		     [ClientKey] = COALESCE(DW.[ClientKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClient] DW  WITH (NOLOCK)
			ON DW.[ClientSSID] = STG.[ClientSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientKey], 0) = 0
			AND STG.[ClientSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [ClientKey]
		---------------------------
		----UPDATE STG SET
		----     [ClientKey] = -1
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[ClientKey] IS NULL

		---------------------------
		------ Fix [ClientSSID]
		---------------------------
		----UPDATE STG SET
		----     [ClientKey] = -1
		----     , [ClientSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[ClientSSID] IS NULL )

		-----------------------
		-- Exception if [ClientSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientSSID] IS NULL


		-----------------------
		-- Exception if [ClientKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientKey] IS NULL
				OR STG.[ClientKey] = 0)


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
