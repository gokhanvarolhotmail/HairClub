/* CreateDate: 06/27/2011 17:22:53.413 , ModifyDate: 10/10/2011 10:54:39.160 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimHairSystemMatrixColor_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimHairSystemMatrixColor_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimHairSystemMatrixColor_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-- 10/10/11 - MB - Changed comparison of "Active" flag to default to empty string instead of 0
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/10/2011  EKnapp       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemMatrixColor]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [HairSystemMatrixColorKey] = DW.[HairSystemMatrixColorKey]
			,IsNew = CASE WHEN DW.[HairSystemMatrixColorKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemMatrixColor] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemMatrixColor] DW ON
				DW.[HairSystemMatrixColorSSID] = STG.[HairSystemMatrixColorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[HairSystemMatrixColorKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemMatrixColor] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemMatrixColor] DW ON
				 STG.[HairSystemMatrixColorSSID] = DW.[HairSystemMatrixColorSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[HairSystemMatrixColorKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemMatrixColor] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemMatrixColor] DW ON
				 STG.[HairSystemMatrixColorSSID] = DW.[HairSystemMatrixColorSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[HairSystemMatrixColorDescription],'') <> COALESCE(DW.[HairSystemMatrixColorDescription],'')
				OR COALESCE(STG.[HairSystemMatrixColorDescriptionShort],'') <> COALESCE(DW.[HairSystemMatrixColorDescriptionShort],'')
				OR COALESCE(STG.[HairSystemMatrixColorSortOrder],'') <> COALESCE(DW.[HairSystemMatrixColorSortOrder],'')
				OR COALESCE(STG.[Active],'N') <> COALESCE(DW.[Active],'N')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[HairSystemMatrixColorKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemMatrixColor] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemMatrixColor] DW ON
				 STG.[HairSystemMatrixColorSSID] = DW.[HairSystemMatrixColorSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[HairSystemMatrixColorDescription],'') <> COALESCE(DW.[HairSystemMatrixColorDescription],'')
			--	OR COALESCE(STG.[HairSystemMatrixColorDescriptionShort],'') <> COALESCE(DW.[HairSystemMatrixColorDescriptionShort],'')
				--OR COALESCE(STG.[HairSystemMatrixColorDataTypeSSID],'') <> COALESCE(DW.[HairSystemMatrixColorDataTypeSSID],'')
				--OR COALESCE(STG.[HairSystemMatrixColorDataTypeDescription],'') <> COALESCE(DW.[HairSystemMatrixColorDataTypeDescription],'')
				--OR COALESCE(STG.[HairSystemMatrixColorDataTypeDescriptionShort],'') <> COALESCE(DW.[HairSystemMatrixColorDataTypeDescriptionShort],'')
				--OR COALESCE(STG.[SchedulerActionTypeSSID],'') <> COALESCE(DW.[SchedulerActionTypeSSID],'')
				--OR COALESCE(STG.[SchedulerActionTypeDescription],'') <> COALESCE(DW.[SchedulerActionTypeDescription],'')
				--OR COALESCE(STG.[SchedulerActionTypeDescriptionShort],'') <> COALESCE(DW.[SchedulerActionTypeDescriptionShort],'')
				--OR COALESCE(STG.[SchedulerAdjustmentTypeSSID],'') <> COALESCE(DW.[SchedulerAdjustmentTypeSSID],'')
				--OR COALESCE(STG.[SchedulerAdjustmentTypeDescription],'') <> COALESCE(DW.[SchedulerAdjustmentTypeDescription],'')
				--OR COALESCE(STG.[SchedulerAdjustmentTypeDescriptionShort],'') <> COALESCE(DW.[SchedulerAdjustmentTypeDescriptionShort],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  HairSystemMatrixColorSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY HairSystemMatrixColorSSID ORDER BY HairSystemMatrixColorSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimHairSystemMatrixColor] STG
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
		FROM [bi_cms_stage].[DimHairSystemMatrixColor] STG
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
