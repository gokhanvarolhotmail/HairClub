/* CreateDate: 06/27/2011 17:23:12.253 , ModifyDate: 11/06/2012 10:57:27.813 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DDS_FactHairSystemOrder_Upsert]
			   @DataPkgKey					int
			 , @IgnoreRowCnt				bigint output
			 , @InsertRowCnt				bigint output
			 , @UpdateRowCnt				bigint output
			 , @ExceptionRowCnt				bigint output
			 , @ExtractRowCnt				bigint output
			 , @InsertNewRowCnt				bigint output
			 , @InsertInferredRowCnt		bigint output
			 , @InsertSCD2RowCnt			bigint output
			 , @UpdateInferredRowCnt		bigint output
			 , @UpdateSCD1RowCnt			bigint output
			 , @UpdateSCD2RowCnt			bigint output
			 , @InitialRowCnt				bigint output
			 , @FinalRowCnt					bigint output

AS
-------------------------------------------------------------------------
-- [spHC_DDS_FactHairSystemOrder_Upsert] is used to determine
-- which records have late arriving dimensions and adds them
--
--
--   exec [bi_cms_stage].[spHC_DDS_FactHairSystemOrder_Upsert] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			11/06/2012  KMurdoch	 Added in ClientHomeCenter
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

	DECLARE		@TableName			varchar(150)	-- Name of table

	DECLARE		  @DeletedRowCnt		bigint
				, @DuplicateRowCnt		bigint
				, @HealthyRowCnt		bigint
				, @RejectedRowCnt		bigint
				, @AllowedRowCnt		bigint
				, @FixedRowCnt			bigint

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'


	BEGIN TRY

		SET @IgnoreRowCnt = 0
		SET @InsertRowCnt = 0
		SET @UpdateRowCnt = 0
		SET @ExceptionRowCnt = 0
		SET @ExtractRowCnt = 0
		SET @InsertNewRowCnt = 0
		SET @InsertInferredRowCnt = 0
		SET @InsertSCD2RowCnt = 0
		SET @UpdateInferredRowCnt = 0
		SET @UpdateSCD1RowCnt = 0
		SET @UpdateSCD2RowCnt = 0
		SET @InitialRowCnt = 0
		SET @FinalRowCnt = 0
		SET @DeletedRowCnt = 0
		SET @DuplicateRowCnt = 0
		SET @HealthyRowCnt = 0
		SET @RejectedRowCnt = 0
		SET @AllowedRowCnt = 0
		SET @FixedRowCnt = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStart] @DataPkgKey, @TableName

		-- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_FactHairSystemOrder]

		-- Determine the number of extracted rows
		SELECT @ExtractRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


		INSERT INTO [bi_cms_stage].[synHC_DDS_FactHairSystemOrder](
            [HairSystemOrderSSID]
           ,[HairSystemOrderNumber]
           ,[HairSystemOrderDateKey]
           ,[HairSystemOrderDate]
           ,[HairSystemDueDateKey]
           ,[HairSystemDueDate]
           ,[HairSystemAllocationDateKey]
           ,[HairSystemAlocationDate]
           ,[HairSystemReceivedDateKey]
           ,[HairSystemReceivedDate]
           ,[HairSystemShippedDateKey]
           ,[HairSystemShippedDate]
           ,[HairSystemAppliedDateKey]
           ,[HairSystemAppliedDate]
           ,[CenterKey]
		   ,[ClientHomeCenterKey]
           ,[ClientKey]
           ,[ClientMembershipKey]
           ,[OrigClientSSID]
           ,[OrigClientMembershipSSID]
           ,[HairSystemHairLengthKey]
           ,[HairSystemTypeKey]
           ,[HairSystemTextureKey]
           ,[HairSystemMatrixColorKey]
           ,[HairSystemDensityKey]
           ,[HairSystemFrontalDensityKey]
           ,[HairSystemStyleKey]
           ,[HairSystemDesignTemplateKey]
           ,[HairSystemRecessionKey]
           ,[HairSystemTopHairColorKey]
           ,[MeasurementsByEmployeeKey]
           ,[CapSizeKey]
           ,[TemplateWidth]
           ,[TemplateHeight]
           ,[TemplateArea]
           ,[HairSystemVendorContractKey]
           ,[FactorySSID]
           ,[HairSystemOrderStatusKey]
           ,[CostContract]
           ,[CostActual]
           ,[PriceContract]
           ,[HairSystemRepairReasonSSID]
           ,[HairSystemRepairReasonDescription]
           ,[HairSystemRedoReasonSSID]
           ,[HairSystemRedoReasonDescription]
           ,[IsOnHoldForReviewFlag]
           ,[IsSampleOrderFlag]
           ,[IsRepairOrderFlag]
           ,[IsRedoOrderFlag]
           ,[IsRushOrderFlag]
           ,[IsStockInventoryFlag]
           ,[InsertAuditKey]
           ,[UpdateAuditKey]

					)
			SELECT
					  STG.[HairSystemOrderSSID]
					  ,STG.[HairSystemOrderNumber]
					  ,STG.[HairSystemOrderDateKey]
					  ,STG.[HairSystemOrderDate]
					  ,STG.[HairSystemDueDateKey]
					  ,STG.[HairSystemDueDate]
					  ,STG.[HairSystemAllocationDateKey]
					  ,STG.[HairSystemAllocationDate]
					  ,STG.[HairSystemReceivedDateKey]
					  ,STG.[HairSystemReceivedDate]
					  ,STG.[HairSystemShippedDateKey]
					  ,STG.[HairSystemShippedDate]
					  ,STG.[HairSystemAppliedDateKey]
					  ,STG.[HairSystemAppliedDate]
					  ,STG.[CenterKey]
					  ,STG.[ClientHomeCenterKey]
					  ,STG.[ClientKey]
					  ,STG.[ClientMembershipKey]
					  ,STG.[OrigClientSSID]
					  ,STG.[OrigClientMembershipSSID]
					  ,STG.[HairSystemHairLengthKey]
					  ,STG.[HairSystemTypeKey]
					  ,STG.[HairSystemTextureKey]
					  ,STG.[HairSystemMatrixColorKey]
					  ,STG.[HairSystemDensityKey]
					  ,STG.[HairSystemFrontalDensityKey]
					  ,STG.[HairSystemStyleKey]
					  ,STG.[HairSystemDesignTemplateKey]
					  ,STG.[HairSystemRecessionKey]
					  ,STG.[HairSystemTopHairColorKey]
					  ,STG.[MeasurementsByEmployeeKey]
					  ,STG.[CapSizeKey]
					  ,STG.[TemplateWidth]
					  ,STG.[TemplateHeight]
					  ,STG.[TemplateArea]
					  ,STG.[HairSystemVendorContractKey]
					  ,STG.[FactorySSID]
					  ,STG.[HairSystemOrderStatusKey]
					  ,STG.[CostContract]
					  ,STG.[CostActual]
					  ,STG.[PriceContract]
					  ,STG.[HairSystemRepairReasonSSID]
					  ,STG.[HairSystemRepairReasonDescription]
					  ,STG.[HairSystemRedoReasonSSID]
					  ,STG.[HairSystemRedoReasonDescription]
					  ,STG.[IsOnHoldForReviewFlag]
					  ,STG.[IsSampleOrderFlag]
					  ,STG.[IsRepairOrderFlag]
					  ,STG.[IsRedoOrderFlag]
					  ,STG.[IsRushOrderFlag]
					  ,STG.[IsStockInventoryFlag]
					, @DataPkgKey
					, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[FactHairSystemOrder] STG
			WHERE	STG.[IsNew] = 1
				AND	STG.[IsException] = 0
				AND STG.[IsDuplicate] = 0
				AND STG.[DataPkgKey] = @DataPkgKey

		SET @InsertNewRowCnt = @@ROWCOUNT

		------------------------
		-- Update Records
		------------------------
		-- Just update the record
		UPDATE DW SET
			  		  DW.[HairSystemOrderSSID] = STG.[HairSystemOrderSSID]
					  ,DW.[HairSystemOrderNumber] = STG.[HairSystemOrderNumber]
					  ,DW.[HairSystemOrderDateKey] = STG.[HairSystemOrderDateKey]
					  ,DW.[HairSystemOrderDate] = STG.[HairSystemOrderDate]
					  ,DW.[HairSystemDueDateKey] = STG.[HairSystemDueDateKey]
					  ,DW.[HairSystemDueDate] = STG.[HairSystemDueDate]
					  ,DW.[HairSystemAllocationDateKey] = STG.[HairSystemAllocationDateKey]
					  ,DW.[HairSystemAlocationDate]= STG.[HairSystemAllocationDate]
					  ,DW.[HairSystemReceivedDateKey]= STG.[HairSystemReceivedDateKey]
					  ,DW.[HairSystemReceivedDate]= STG.[HairSystemReceivedDate]
					  ,DW.[HairSystemShippedDateKey]= STG.[HairSystemShippedDateKey]
					  ,DW.[HairSystemShippedDate]= STG.[HairSystemShippedDate]
					  ,DW.[HairSystemAppliedDateKey]= STG.[HairSystemAppliedDateKey]
					  ,DW.[HairSystemAppliedDate]= STG.[HairSystemAppliedDate]
					  ,DW.[CenterKey]= STG.[CenterKey]
					  ,DW.[ClientHomeCenterKey]= STG.[ClientHomeCenterKey]
					  ,DW.[ClientKey]= STG.[ClientKey]
					  ,DW.[ClientMembershipKey]= STG.[ClientMembershipKey]
					  ,DW.[OrigClientSSID]= STG.[OrigClientSSID]
					  ,DW.[OrigClientMembershipSSID]= STG.[OrigClientMembershipSSID]
					  ,DW.[HairSystemHairLengthKey]= STG.[HairSystemHairLengthKey]
					  ,DW.[HairSystemTypeKey]= STG.[HairSystemTypeKey]
					  ,DW.[HairSystemTextureKey]= STG.[HairSystemTextureKey]
					  ,DW.[HairSystemMatrixColorKey]= STG.[HairSystemMatrixColorKey]
					  ,DW.[HairSystemDensityKey]= STG.[HairSystemDensityKey]
					  ,DW.[HairSystemFrontalDensityKey]= STG.[HairSystemFrontalDensityKey]
					  ,DW.[HairSystemStyleKey]= STG.[HairSystemStyleKey]
					  ,DW.[HairSystemDesignTemplateKey]= STG.[HairSystemDesignTemplateKey]
					  ,DW.[HairSystemRecessionKey]= STG.[HairSystemRecessionKey]
					  ,DW.[HairSystemTopHairColorKey]= STG.[HairSystemTopHairColorKey]
					  ,DW.[MeasurementsByEmployeeKey]= STG.[MeasurementsByEmployeeKey]
					  ,DW.[CapSizeKey]= STG.[CapSizeKey]
					  ,DW.[TemplateWidth]= STG.[TemplateWidth]
					  ,DW.[TemplateHeight]= STG.[TemplateHeight]
					  ,DW.[TemplateArea]= STG.[TemplateArea]
					  ,DW.[HairSystemVendorContractKey]= STG.[HairSystemVendorContractKey]
					  ,DW.[FactorySSID]= STG.[FactorySSID]
					  ,DW.[HairSystemOrderStatusKey]= STG.[HairSystemOrderStatusKey]
					  ,DW.[CostContract]= STG.[CostContract]
					  ,DW.[CostActual]= STG.[CostActual]
					  ,DW.[PriceContract]= STG.[PriceContract]
					  ,DW.[HairSystemRepairReasonSSID]= STG.[HairSystemRepairReasonSSID]
					  ,DW.[HairSystemRepairReasonDescription]= STG.[HairSystemRepairReasonDescription]
					  ,DW.[HairSystemRedoReasonSSID]= STG.[HairSystemRedoReasonSSID]
					  ,DW.[HairSystemRedoReasonDescription]= STG.[HairSystemRedoReasonDescription]
					  ,DW.[IsOnHoldForReviewFlag]= STG.[IsOnHoldForReviewFlag]
					  ,DW.[IsSampleOrderFlag]= STG.[IsSampleOrderFlag]
					  ,DW.[IsRepairOrderFlag]= STG.[IsRepairOrderFlag]
					  ,DW.[IsRedoOrderFlag]= STG.[IsRedoOrderFlag]
					  ,DW.[IsRushOrderFlag]= STG.[IsRushOrderFlag]
					  ,DW.[IsStockInventoryFlag]= STG.[IsStockInventoryFlag]
			         , DW.[UpdateAuditKey] = @DataPkgKey
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		JOIN [bi_cms_stage].[synHC_DDS_FactHairSystemOrder] DW WITH (NOLOCK)
			ON DW.[HairSystemOrderKey] = STG.[HairSystemOrderKey]
		WHERE	STG.[IsUpdate] = 1
			AND	STG.[IsException] = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		SET @UpdateSCD1RowCnt = @@ROWCOUNT



		-- Determine the number of exception rows
		SELECT @ExceptionRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[IsException] = 1
			AND STG.[DataPkgKey] = @DataPkgKey

		-- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt

		-- Determine the number of ignored rows
		SELECT @IgnoreRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[IsException] = 0
		AND STG.[IsNew] = 0
		AND STG.[IsUpdate] = 0
		AND STG.[IsDelete] = 0
		OR STG.[IsDuplicate] = 1
		AND STG.[DataPkgKey] = @DataPkgKey



		-- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_FactHairSystemOrder]


		-- Determine the number of Fixed rows
		SELECT @FixedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsFixed] = 1

		-- Determine the number of Allowed rows
		SELECT @AllowedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsAllowed] = 1

		-- Determine the number of Rejected rows
		SELECT @RejectedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 1

		-- Determine the number of Healthy rows
		SELECT @HealthyRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsRejected] = 0
		AND STG.[IsAllowed] = 0
		AND STG.[IsFixed] = 0

		-- Determine the number of Duplicate rows
		SELECT @DuplicateRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDuplicate] = 1

		-- Determine the number of Deleted rows
		SELECT @DeletedRowCnt = COUNT(1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[IsDelete] = 1

		-----------------------
		-- Flag records as loaded
		-----------------------
		UPDATE STG SET
			IsLoaded = 1
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE DataPkgKey = @DataPkgKey
			AND	STG.[IsException] = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadStop] @DataPkgKey, @TableName
					, @IgnoreRowCnt, @InsertRowCnt, @UpdateRowCnt, @ExceptionRowCnt, @ExtractRowCnt
					, @InsertNewRowCnt, @InsertInferredRowCnt, @InsertSCD2RowCnt
					, @UpdateInferredRowCnt, @UpdateSCD1RowCnt, @UpdateSCD2RowCnt
					, @InitialRowCnt, @FinalRowCnt
					, @DeletedRowCnt, @DuplicateRowCnt, @HealthyRowCnt
					, @RejectedRowCnt, @AllowedRowCnt, @FixedRowCnt

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
