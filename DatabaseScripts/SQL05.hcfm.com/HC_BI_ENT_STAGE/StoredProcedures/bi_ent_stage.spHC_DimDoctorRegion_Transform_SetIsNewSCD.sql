/* CreateDate: 05/03/2010 12:09:53.390 , ModifyDate: 05/03/2010 12:09:53.390 */
GO
CREATE PROCEDURE [bi_ent_stage].[spHC_DimDoctorRegion_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimDoctorRegion_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_ent_stage].[spHC_DimDoctorRegion_Transform_SetIsNewSCD] 422
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

 	SET @TableName = N'[bi_ent_dds].[DimDoctorRegion]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [DoctorRegionKey] = DW.[DoctorRegionKey]
			,IsNew = CASE WHEN DW.[DoctorRegionKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimDoctorRegion] STG
		LEFT OUTER JOIN [bi_ent_stage].[synHC_DDS_DimDoctorRegion] DW ON
				DW.[DoctorRegionSSID] = STG.[DoctorRegionSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[DoctorRegionKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimDoctorRegion] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimDoctorRegion] DW ON
				 STG.[DoctorRegionSSID] = DW.[DoctorRegionSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[DoctorRegionKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimDoctorRegion] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimDoctorRegion] DW ON
				 STG.[DoctorRegionSSID] = DW.[DoctorRegionSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[DoctorRegionDescription],'') <> COALESCE(DW.[DoctorRegionDescription],'')
				OR COALESCE(STG.[DoctorRegionDescriptionShort],'') <> COALESCE(DW.[DoctorRegionDescriptionShort],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[DoctorRegionKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_ent_stage].[DimDoctorRegion] STG
		INNER JOIN [bi_ent_stage].[synHC_DDS_DimDoctorRegion] DW ON
				 STG.[DoctorRegionSSID] = DW.[DoctorRegionSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[DoctorRegionDescription],'') <> COALESCE(DW.[DoctorRegionDescription],'')
			--	OR COALESCE(STG.[DoctorRegionDescriptionShort],'') <> COALESCE(DW.[DoctorRegionDescriptionShort],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  DoctorRegionSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY DoctorRegionSSID ORDER BY DoctorRegionSSID ) AS RowNum
			   FROM  [bi_ent_stage].[DimDoctorRegion] STG
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
		FROM [bi_ent_stage].[DimDoctorRegion] STG
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
