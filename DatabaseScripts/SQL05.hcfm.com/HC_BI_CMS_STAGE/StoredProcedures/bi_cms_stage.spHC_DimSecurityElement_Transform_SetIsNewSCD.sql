/* CreateDate: 08/09/2012 16:50:16.187 , ModifyDate: 08/09/2012 16:50:16.187 */
GO
create PROCEDURE [bi_cms_stage].[spHC_DimSecurityElement_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSecurityElement_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimSecurityElement_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/09/2012  KMurdoch     Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimSecurityElement]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [SecurityElementKey] = DW.[SecurityElementKey]
			,IsNew = CASE WHEN DW.[SecurityElementKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSecurityElement] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSecurityElement] DW ON
				DW.[SecurityElementSSID] = STG.[SecurityElementSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[SecurityElementKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSecurityElement] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSecurityElement] DW ON
				 STG.[SecurityElementSSID] = DW.[SecurityElementSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[SecurityElementKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSecurityElement] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSecurityElement] DW ON
				 STG.[SecurityElementSSID] = DW.[SecurityElementSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[SecurityElementDescription],'') <> COALESCE(DW.[SecurityElementDescription],'')
				OR COALESCE(STG.[SecurityElementDescriptionShort],'') <> COALESCE(DW.[SecurityElementDescriptionShort],'')
				OR COALESCE(STG.[SecurityElementSortOrder],'') <> COALESCE(DW.[SecurityElementSortOrder],'')
				OR COALESCE(STG.[Active],'N') <> COALESCE(DW.[Active],'N')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[SecurityElementKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSecurityElement] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSecurityElement] DW ON
				 STG.[SecurityElementSSID] = DW.[SecurityElementSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[SecurityElementDescription],'') <> COALESCE(DW.[SecurityElementDescription],'')
			--	OR COALESCE(STG.[SecurityElementDescriptionShort],'') <> COALESCE(DW.[SecurityElementDescriptionShort],'')
				--OR COALESCE(STG.[SecurityElementDataTypeSSID],'') <> COALESCE(DW.[SecurityElementDataTypeSSID],'')
				--OR COALESCE(STG.[SecurityElementDataTypeDescription],'') <> COALESCE(DW.[SecurityElementDataTypeDescription],'')
				--OR COALESCE(STG.[SecurityElementDataTypeDescriptionShort],'') <> COALESCE(DW.[SecurityElementDataTypeDescriptionShort],'')
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
			(SELECT  SecurityElementSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY SecurityElementSSID ORDER BY SecurityElementSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimSecurityElement] STG
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
		FROM [bi_cms_stage].[DimSecurityElement] STG
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
