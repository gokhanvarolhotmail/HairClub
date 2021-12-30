/* CreateDate: 05/03/2010 12:09:46.893 , ModifyDate: 05/03/2010 12:09:46.893 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimCenterOwnership_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimCenterOwnership_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_ent_stage].[spHC_DimCenterOwnership_Transform_SetIsNewSCD] 422
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

 	SET @TableName = N'[bi_ent_dds].[DimCenterOwnership]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [CenterOwnershipKey] = DW.[CenterOwnershipKey]
			,IsNew = CASE WHEN DW.[CenterOwnershipKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenterOwnership] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimCenterOwnership] DW ON
				DW.[CenterOwnershipSSID] = STG.[CenterOwnershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[CenterOwnershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenterOwnership] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimCenterOwnership] DW ON
				 STG.[CenterOwnershipSSID] = DW.[CenterOwnershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[CenterOwnershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenterOwnership] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimCenterOwnership] DW ON
				 STG.[CenterOwnershipSSID] = DW.[CenterOwnershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[CenterOwnershipDescription],'') <> COALESCE(DW.[CenterOwnershipDescription],'')
				OR COALESCE(STG.[CenterOwnershipDescriptionShort],'') <> COALESCE(DW.[CenterOwnershipDescriptionShort],'')
				OR COALESCE(STG.[OwnerLastName],'') <> COALESCE(DW.[OwnerLastName],'')
				OR COALESCE(STG.[OwnerFirstName],'') <> COALESCE(DW.[OwnerFirstName],'')
				OR COALESCE(STG.[CorporateName],'') <> COALESCE(DW.[CorporateName],'')
				OR COALESCE(STG.[CenterAddress1],'') <> COALESCE(DW.[CenterAddress1],'')
				OR COALESCE(STG.[CenterAddress2],'') <> COALESCE(DW.[CenterAddress2],'')
				OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[CenterOwnershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenterOwnership] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimCenterOwnership] DW ON
				 STG.[CenterOwnershipSSID] = DW.[CenterOwnershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[CenterOwnershipDescription],'') <> COALESCE(DW.[CenterOwnershipDescription],'')
			--	OR COALESCE(STG.[CenterOwnershipDescriptionShort],'') <> COALESCE(DW.[CenterOwnershipDescriptionShort],'')
				--OR COALESCE(STG.[OwnerLastName],'') <> COALESCE(DW.[OwnerLastName],'')
				--OR COALESCE(STG.[OwnerFirstName],'') <> COALESCE(DW.[OwnerFirstName],'')
				--OR COALESCE(STG.[CorporateName],'') <> COALESCE(DW.[CorporateName],'')
				--OR COALESCE(STG.[CenterAddress1],'') <> COALESCE(DW.[CenterAddress1],'')
				--OR COALESCE(STG.[CenterAddress2],'') <> COALESCE(DW.[CenterAddress2],'')
				--OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				--OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				--OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				--OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				--OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				--OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  CenterOwnershipSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY CenterOwnershipSSID ORDER BY CenterOwnershipSSID ) AS RowNum
			   FROM  [bi_ent_stage].[DimCenterOwnership] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)

			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1

		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimCenterOwnership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey



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
