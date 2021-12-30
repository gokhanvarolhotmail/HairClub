/* CreateDate: 10/05/2010 14:04:33.910 , ModifyDate: 07/21/2015 08:48:20.953 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulatorAdjustment_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorAdjustment]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

						-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Extraction Completed'
					WHERE [TableName] = @TableName
		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [AccumulatorAdjustmentKey] = DW.[AccumulatorAdjustmentKey]
			,IsNew = CASE WHEN DW.[AccumulatorAdjustmentKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulatorAdjustment] DW ON
				DW.[AccumulatorAdjustmentSSID] = STG.[AccumulatorAdjustmentSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[AccumulatorAdjustmentKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulatorAdjustment] DW ON
				 STG.[AccumulatorAdjustmentSSID] = DW.[AccumulatorAdjustmentSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[AccumulatorAdjustmentKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulatorAdjustment] DW ON
				 STG.[AccumulatorAdjustmentSSID] = DW.[AccumulatorAdjustmentSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[ClientMembershipSSID],'') <> COALESCE(DW.[ClientMembershipSSID],'')
				OR COALESCE(STG.[SalesOrderDetailSSID],'') <> COALESCE(DW.[SalesOrderDetailSSID],'')
				OR COALESCE(STG.[AppointmentSSID],'') <> COALESCE(DW.[AppointmentSSID],'')
				OR COALESCE(STG.[AccumulatorSSID],'') <> COALESCE(DW.[AccumulatorSSID],'')
				OR COALESCE(STG.[AccumulatorDescription],'') <> COALESCE(DW.[AccumulatorDescription],'')
				OR COALESCE(STG.[AccumulatorDescriptionShort],'') <> COALESCE(DW.[AccumulatorDescriptionShort],'')
				OR COALESCE(STG.[QuantityUsedOriginal],0) <> COALESCE(DW.[QuantityUsedOriginal],0)
				OR COALESCE(STG.[QuantityUsedAdjustment],0) <> COALESCE(DW.[QuantityUsedAdjustment],0)
				OR COALESCE(STG.[QuantityTotalOriginal],0) <> COALESCE(DW.[QuantityTotalOriginal],0)
				OR COALESCE(STG.[QuantityTotalAdjustment],0) <> COALESCE(DW.[QuantityTotalAdjustment],0)
				OR COALESCE(STG.[MoneyOriginal],0) <> COALESCE(DW.[MoneyOriginal],0)
				OR COALESCE(STG.[MoneyAdjustment],0) <> COALESCE(DW.[MoneyAdjustment],0)
				OR COALESCE(STG.[DateOriginal],'') <> COALESCE(DW.[DateOriginal],'')
				OR COALESCE(STG.[DateAdjustment],'') <> COALESCE(DW.[DateAdjustment],'')
				OR COALESCE(STG.[QuantityUsedNew],0) <> COALESCE(DW.[QuantityUsedNew],0)
				OR COALESCE(STG.[QuantityUsedChange],0) <> COALESCE(DW.[QuantityUsedChange],0)
				OR COALESCE(STG.[QuantityTotalNew],0) <> COALESCE(DW.[QuantityTotalNew],0)
				OR COALESCE(STG.[QuantityTotalChange],0) <> COALESCE(DW.[QuantityTotalChange],0)
				OR COALESCE(STG.[MoneyNew],0) <> COALESCE(DW.[MoneyNew],0)
				OR COALESCE(STG.[MoneyChange],0) <> COALESCE(DW.[MoneyChange],0)
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[AccumulatorAdjustmentKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAccumulatorAdjustment] DW ON
				 STG.[AccumulatorAdjustmentSSID] = DW.[AccumulatorAdjustmentSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[ClientMembershipSSID],'') <> COALESCE(DW.[ClientMembershipSSID],'')
				--OR COALESCE(STG.[SalesOrderDetailSSID],'') <> COALESCE(DW.[SalesOrderDetailSSID],'')
				--OR COALESCE(STG.[AppointmentSSID],'') <> COALESCE(DW.[AppointmentSSID],'')
				--OR COALESCE(STG.[AccumulatorSSID],'') <> COALESCE(DW.[AccumulatorSSID],'')
				--OR COALESCE(STG.[AccumulatorDescription],'') <> COALESCE(DW.[AccumulatorDescription],'')
				--OR COALESCE(STG.[AccumulatorDescriptionShort],'') <> COALESCE(DW.[AccumulatorDescriptionShort],'')
				--OR COALESCE(STG.[QuantityUsedOriginal],0) <> COALESCE(DW.[QuantityUsedOriginal],0)
				--OR COALESCE(STG.[QuantityUsedAdjustment],0) <> COALESCE(DW.[QuantityUsedAdjustment],0)
				--OR COALESCE(STG.[QuantityTotalOriginal],0) <> COALESCE(DW.[QuantityTotalOriginal],0)
				--OR COALESCE(STG.[QuantityTotalAdjustment],0) <> COALESCE(DW.[QuantityTotalAdjustment],0)
				--OR COALESCE(STG.[MoneyOriginal],0) <> COALESCE(DW.[MoneyOriginal],0)
				--OR COALESCE(STG.[MoneyAdjustment],0) <> COALESCE(DW.[MoneyAdjustment],0)
				--OR COALESCE(STG.[DateOriginal],'') <> COALESCE(DW.[DateOriginal],'')
				--OR COALESCE(STG.[DateAdjustment],'') <> COALESCE(DW.[DateAdjustment],'')
				--OR COALESCE(STG.[QuantityUsedNew],0) <> COALESCE(DW.[QuantityUsedNew],0)
				--OR COALESCE(STG.[QuantityUsedChange],0) <> COALESCE(DW.[QuantityUsedChange],0)
				--OR COALESCE(STG.[QuantityTotalNew],0) <> COALESCE(DW.[QuantityTotalNew],0)
				--OR COALESCE(STG.[QuantityTotalChange],0) <> COALESCE(DW.[QuantityTotalChange],0)
				--OR COALESCE(STG.[MoneyNew],0) <> COALESCE(DW.[MoneyNew],0)
				--OR COALESCE(STG.[MoneyChange],0) <> COALESCE(DW.[MoneyChange],0)
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  AccumulatorAdjustmentSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY AccumulatorAdjustmentSSID ORDER BY AccumulatorAdjustmentSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimAccumulatorAdjustment] STG
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
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
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
