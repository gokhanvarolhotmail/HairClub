/* CreateDate: 06/27/2011 17:23:47.747 , ModifyDate: 10/26/2011 11:21:56.707 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_HairSystemOrderStatusKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Transform_Lkup_HairSystemOrderStatusKey] is used to determine
-- the HairSystemOrderStatusKey foreign key values in the FactHairSystemOrder table using DimHairSystemOrderStatus.
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
		       [HairSystemOrderStatusKey]  = -1
		     , [HairSystemOrderStatusSSID] = -2
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[HairSystemOrderStatusSSID]) <> 1)


		------------------------
		-- There might be some other load that just added them
		-- Update [HairSystemOrderStatusKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [HairSystemOrderStatusKey] = COALESCE(DW.[HairSystemOrderStatusKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemOrderStatus] DW  WITH (NOLOCK)
			ON DW.[HairSystemOrderStatusSSID] = STG.[HairSystemOrderStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.HairSystemOrderStatusKey, 0) = 0
			AND STG.[HairSystemOrderStatusSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactHairSystemOrder_LoadInferred_DimHairSystemOrderStatus] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [HairSystemOrderStatusKey] = COALESCE(DW.[HairSystemOrderStatusKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemOrderStatus] DW  WITH (NOLOCK)
			ON DW.[HairSystemOrderStatusSSID] = STG.[HairSystemOrderStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[HairSystemOrderStatusKey], 0) = 0
			AND STG.[HairSystemOrderStatusSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [HairSystemOrderStatusKey]
		---------------------------
		----UPDATE STG SET
		----     [HairSystemOrderStatusKey] = -1
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[HairSystemOrderStatusKey] IS NULL

		---------------------------
		------ Fix [HairSystemOrderStatusSSID]
		---------------------------
		----UPDATE STG SET
		----       [HairSystemOrderStatusKey]  = -1
		----     , [HairSystemOrderStatusSSID] = -2
		----FROM [bi_cms_stage].[FactHairSystemOrder] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[HairSystemOrderStatusSSID] IS NULL )

		-----------------------
		-- Exception if [HairSystemOrderStatusSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemOrderStatusSSID is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairSystemOrderStatusSSID] IS NULL


		-----------------------
		-- Exception if [HairSystemOrderStatusKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'HairSystemOrderStatusKey is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairSystemOrderStatusKey] IS NULL
				OR STG.[HairSystemOrderStatusKey] = 0)


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
