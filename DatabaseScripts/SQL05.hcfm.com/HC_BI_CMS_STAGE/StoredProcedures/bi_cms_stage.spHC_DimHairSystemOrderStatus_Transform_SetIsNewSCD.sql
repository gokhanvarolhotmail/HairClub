/* CreateDate: 06/27/2011 17:22:53.310 , ModifyDate: 06/27/2011 17:22:53.310 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimHairSystemOrderStatus_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimHairSystemOrderStatus_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimHairSystemOrderStatus_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
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

 	SET @TableName = N'[bi_cms_dds].[DimHairSystemOrderStatus]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [HairSystemOrderStatusKey] = DW.[HairSystemOrderStatusKey]
			,IsNew = CASE WHEN DW.[HairSystemOrderStatusKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemOrderStatus] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemOrderStatus] DW ON
				DW.[HairSystemOrderStatusSSID] = STG.[HairSystemOrderStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[HairSystemOrderStatusKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemOrderStatus] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemOrderStatus] DW ON
				 STG.[HairSystemOrderStatusSSID] = DW.[HairSystemOrderStatusSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[HairSystemOrderStatusKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemOrderStatus] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemOrderStatus] DW ON
				 STG.[HairSystemOrderStatusSSID] = DW.[HairSystemOrderStatusSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[HairSystemOrderStatusDescription],'') <> COALESCE(DW.[HairSystemOrderStatusDescription],'')
				OR COALESCE(STG.[HairSystemOrderStatusDescriptionShort],'') <> COALESCE(DW.[HairSystemOrderStatusDescriptionShort],'')
				OR COALESCE(STG.[HairSystemOrderStatusSortOrder],'') <> COALESCE(DW.[HairSystemOrderStatusSortOrder],'')
				OR COALESCE(STG.[Active],'N') <> COALESCE(DW.[Active],'N')
				OR COALESCE(STG.[CanApplyFlag],'N') <> COALESCE(DW.[CanApplyFlag],'N')
				OR COALESCE(STG.[CanTransferFlag],'N') <> COALESCE(DW.[CanTransferFlag],'N')
				OR COALESCE(STG.[CanEditFlag],'N') <> COALESCE(DW.[CanEditFlag],'N')
				OR COALESCE(STG.[IsActiveFlag],'N') <> COALESCE(DW.[IsActiveFlag],'N')
				OR COALESCE(STG.[CanCancelFlag],'N') <> COALESCE(DW.[CanCancelFlag],'N')
				OR COALESCE(STG.[IsPreallocationFlag],'N') <> COALESCE(DW.[IsPreallocationFlag],'N')
				OR COALESCE(STG.[CanRedoFlag],'N') <> COALESCE(DW.[CanRedoFlag],'N')
				OR COALESCE(STG.[CanRepairFlag],'N') <> COALESCE(DW.[CanRepairFlag],'N')
				OR COALESCE(STG.[ShowInHistoryFlag],'N') <> COALESCE(DW.[ShowInHistoryFlag],'N')
				OR COALESCE(STG.[CanAddToStockFlag],'N') <> COALESCE(DW.[CanAddToStockFlag],'N')
				OR COALESCE(STG.[IncludeInMembershipCountFlag],'N') <> COALESCE(DW.[IncludeInMembershipCountFlag],'N')
				OR COALESCE(STG.[CanRequestCreditFlag],'N') <> COALESCE(DW.[CanRequestCreditFlag],'N')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[HairSystemOrderStatusKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimHairSystemOrderStatus] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimHairSystemOrderStatus] DW ON
				 STG.[HairSystemOrderStatusSSID] = DW.[HairSystemOrderStatusSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[HairSystemOrderStatusDescription],'') <> COALESCE(DW.[HairSystemOrderStatusDescription],'')
			--	OR COALESCE(STG.[HairSystemOrderStatusDescriptionShort],'') <> COALESCE(DW.[HairSystemOrderStatusDescriptionShort],'')
				--OR COALESCE(STG.[HairSystemOrderStatusDataTypeSSID],'') <> COALESCE(DW.[HairSystemOrderStatusDataTypeSSID],'')
				--OR COALESCE(STG.[HairSystemOrderStatusDataTypeDescription],'') <> COALESCE(DW.[HairSystemOrderStatusDataTypeDescription],'')
				--OR COALESCE(STG.[HairSystemOrderStatusDataTypeDescriptionShort],'') <> COALESCE(DW.[HairSystemOrderStatusDataTypeDescriptionShort],'')
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
			(SELECT  HairSystemOrderStatusSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY HairSystemOrderStatusSSID ORDER BY HairSystemOrderStatusSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimHairSystemOrderStatus] STG
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
		FROM [bi_cms_stage].[DimHairSystemOrderStatus] STG
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
