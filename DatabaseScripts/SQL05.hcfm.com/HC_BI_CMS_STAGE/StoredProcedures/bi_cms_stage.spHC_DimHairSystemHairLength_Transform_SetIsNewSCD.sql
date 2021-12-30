/* CreateDate: 06/27/2011 17:22:53.773 , ModifyDate: 10/10/2011 10:54:24.650 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimHairSystemHairLength_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimHairSystemHairLength_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimHairSystemHairLength_Transform_SetIsNewSCD] 422
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemHairLength]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [HairSystemHairLengthKey] = DW.[HairSystemHairLengthKey]
			,IsNew = CASE WHEN DW.[HairSystemHairLengthKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemHairLength] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemHairLength] DW ON
				DW.[HairSystemHairLengthSSID] = STG.[HairSystemHairLengthSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[HairSystemHairLengthKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemHairLength] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemHairLength] DW ON
				 STG.[HairSystemHairLengthSSID] = DW.[HairSystemHairLengthSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[HairSystemHairLengthKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemHairLength] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemHairLength] DW ON
				 STG.[HairSystemHairLengthSSID] = DW.[HairSystemHairLengthSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[HairSystemHairLengthDescription],'') <> COALESCE(DW.[HairSystemHairLengthDescription],'')
				OR COALESCE(STG.[HairSystemHairLengthDescriptionShort],'') <> COALESCE(DW.[HairSystemHairLengthDescriptionShort],'')
				OR COALESCE(STG.[HairSystemHairLengthValue],'') <> COALESCE(DW.[HairSystemHairLengthValue],'')
				OR COALESCE(STG.[HairSystemHairLengthSortOrder],'') <> COALESCE(DW.[HairSystemHairLengthSortOrder],'')
				OR COALESCE(STG.[Active],'N') <> COALESCE(DW.[Active],'N')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[HairSystemHairLengthKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemHairLength] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemHairLength] DW ON
				 STG.[HairSystemHairLengthSSID] = DW.[HairSystemHairLengthSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[HairSystemHairLengthDescription],'') <> COALESCE(DW.[HairSystemHairLengthDescription],'')
			--	OR COALESCE(STG.[HairSystemHairLengthDescriptionShort],'') <> COALESCE(DW.[HairSystemHairLengthDescriptionShort],'')
				--OR COALESCE(STG.[HairSystemHairLengthDataTypeSSID],'') <> COALESCE(DW.[HairSystemHairLengthDataTypeSSID],'')
				--OR COALESCE(STG.[HairSystemHairLengthDataTypeDescription],'') <> COALESCE(DW.[HairSystemHairLengthDataTypeDescription],'')
				--OR COALESCE(STG.[HairSystemHairLengthDataTypeDescriptionShort],'') <> COALESCE(DW.[HairSystemHairLengthDataTypeDescriptionShort],'')
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
			(SELECT  HairSystemHairLengthSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY HairSystemHairLengthSSID ORDER BY HairSystemHairLengthSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimHairSystemHairLength] STG
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
		FROM [bi_cms_stage].[DimHairSystemHairLength] STG
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
