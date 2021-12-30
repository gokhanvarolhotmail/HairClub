/* CreateDate: 05/03/2010 12:19:52.407 , ModifyDate: 05/03/2010 12:19:52.407 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulator_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulator_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimAccumulator_Transform_SetIsNewSCD] 422
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulator]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [AccumulatorKey] = DW.[AccumulatorKey]
			,IsNew = CASE WHEN DW.[AccumulatorKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulator] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulator] DW ON
				DW.[AccumulatorSSID] = STG.[AccumulatorSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[AccumulatorKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulator] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulator] DW ON
				 STG.[AccumulatorSSID] = DW.[AccumulatorSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[AccumulatorKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulator] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulator] DW ON
				 STG.[AccumulatorSSID] = DW.[AccumulatorSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[AccumulatorDescription],'') <> COALESCE(DW.[AccumulatorDescription],'')
				OR COALESCE(STG.[AccumulatorDescriptionShort],'') <> COALESCE(DW.[AccumulatorDescriptionShort],'')
				OR COALESCE(STG.[AccumulatorDataTypeSSID],'') <> COALESCE(DW.[AccumulatorDataTypeSSID],'')
				OR COALESCE(STG.[AccumulatorDataTypeDescription],'') <> COALESCE(DW.[AccumulatorDataTypeDescription],'')
				OR COALESCE(STG.[AccumulatorDataTypeDescriptionShort],'') <> COALESCE(DW.[AccumulatorDataTypeDescriptionShort],'')
				OR COALESCE(STG.[SchedulerActionTypeSSID],'') <> COALESCE(DW.[SchedulerActionTypeSSID],'')
				OR COALESCE(STG.[SchedulerActionTypeDescription],'') <> COALESCE(DW.[SchedulerActionTypeDescription],'')
				OR COALESCE(STG.[SchedulerActionTypeDescriptionShort],'') <> COALESCE(DW.[SchedulerActionTypeDescriptionShort],'')
				OR COALESCE(STG.[SchedulerAdjustmentTypeSSID],'') <> COALESCE(DW.[SchedulerAdjustmentTypeSSID],'')
				OR COALESCE(STG.[SchedulerAdjustmentTypeDescription],'') <> COALESCE(DW.[SchedulerAdjustmentTypeDescription],'')
				OR COALESCE(STG.[SchedulerAdjustmentTypeDescriptionShort],'') <> COALESCE(DW.[SchedulerAdjustmentTypeDescriptionShort],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[AccumulatorKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulator] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulator] DW ON
				 STG.[AccumulatorSSID] = DW.[AccumulatorSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[AccumulatorDescription],'') <> COALESCE(DW.[AccumulatorDescription],'')
			--	OR COALESCE(STG.[AccumulatorDescriptionShort],'') <> COALESCE(DW.[AccumulatorDescriptionShort],'')
				--OR COALESCE(STG.[AccumulatorDataTypeSSID],'') <> COALESCE(DW.[AccumulatorDataTypeSSID],'')
				--OR COALESCE(STG.[AccumulatorDataTypeDescription],'') <> COALESCE(DW.[AccumulatorDataTypeDescription],'')
				--OR COALESCE(STG.[AccumulatorDataTypeDescriptionShort],'') <> COALESCE(DW.[AccumulatorDataTypeDescriptionShort],'')
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
			(SELECT  AccumulatorSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY AccumulatorSSID ORDER BY AccumulatorSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimAccumulator] STG
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
		FROM [bi_cms_stage].[DimAccumulator] STG
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
