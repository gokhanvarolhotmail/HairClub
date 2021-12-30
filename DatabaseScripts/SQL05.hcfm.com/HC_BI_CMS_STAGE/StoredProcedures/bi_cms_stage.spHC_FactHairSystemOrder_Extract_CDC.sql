/* CreateDate: 06/27/2011 17:38:23.850 , ModifyDate: 12/12/2012 16:24:12.473 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Extract_CDC] is used to retrieve a
-- list SalesOrder
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2011  KMurdoch     Initial Creation
--			09/08/2011	KMurdoch	 Fixed Calculated column CDC Issue
--			09/20/2011  KMurdoch	 Changed Center derivation to ClientHomeCenter
--			11/06/2012	KMurdoch	 Added ClientHomeCenter; changed derivation back to Center
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'
 	SET @CDCTableName = N'dbo_datHairSystemOrder'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


							INSERT INTO [bi_cms_stage].[FactHairSystemOrder]
							   ( [DataPkgKey]
							   ,[HairSystemOrderKey]
							   ,[HairSystemOrderSSID]
							   ,[HairSystemOrderNumber]
							   ,[HairSystemOrderDateKey]
							   ,[HairSystemOrderDate]
							   ,[HairSystemDueDateKey]
							   ,[HairSystemDueDate]
							   ,[HairSystemAllocationDateKey]
							   ,[HairSystemAllocationDate]
							   ,[HairSystemReceivedDateKey]
							   ,[HairSystemReceivedDate]
							   ,[HairSystemShippedDateKey]
							   ,[HairSystemShippedDate]
							   ,[HairSystemAppliedDateKey]
							   ,[HairSystemAppliedDate]
							   ,[CenterKey]
							   ,[CenterSSID]
							   ,[ClientHomeCenterKey]
							   ,[ClientHomeCenterSSID]
							   ,[ClientKey]
							   ,[ClientSSID]
							   ,[ClientMembershipKey]
							   ,[ClientMembershipSSID]
							   ,[OrigClientSSID]
							   ,[OrigClientMembershipSSID]
							   ,[HairSystemHairLengthKey]
							   ,[HairSystemHairLengthSSID]
							   ,[HairSystemTypeKey]
							   ,[HairSystemTypeSSID]
							   ,[HairSystemTextureKey]
							   ,[HairSystemTextureSSID]
							   ,[HairSystemMatrixColorKey]
							   ,[HairSystemMatrixColorSSID]
							   ,[HairSystemDensityKey]
							   ,[HairSystemDensitySSID]
							   ,[HairSystemFrontalDensityKey]
							   ,[HairSystemFrontalDensitySSID]
							   ,[HairSystemStyleKey]
							   ,[HairSystemStyleSSID]
							   ,[HairSystemDesignTemplateKey]
							   ,[HairSystemDesignTemplateSSID]
							   ,[HairSystemRecessionKey]
							   ,[HairSystemRecessionSSID]
							   ,[HairSystemTopHairColorKey]
							   ,[HairSystemTopHairColorSSID]
							   ,[MeasurementsByEmployeeKey]
							   ,[MeasurementsByEmployeeSSID]
							   ,[CapSizeKey]
							   ,[TemplateWidth]
							   ,[TemplateHeight]
							   ,[TemplateArea]
							   ,[HairSystemVendorContractKey]
							   ,[HairSystemVendorContractSSID]
							   ,[FactorySSID]
							   ,[HairSystemOrderStatusKey]
							   ,[HairSystemOrderStatusSSID]
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
							   ,[IsException]
							   ,[IsDelete]
							   ,[IsDuplicate]
							   ,[SourceSystemKey]
								)
							SELECT @DataPkgKey
								, NULL AS [HairSystemOrderKey]
								, COALESCE(chg.[HairSystemOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [HairSystemOrderSSID]
								, chg.HairSystemOrderNumber as [HairSystemOrderNumber]
							    , 0 AS [HairSystemOrderDateKey]
							    , chg.HairSystemOrderDate as 'HairSystemOrderDate'
							    , 0 AS [HairSystemDueDateKey]
							    , chg.DueDate as 'HairSystemDueDate'
								, 0 AS [HairSystemAllocationDateKey]
								, [bief_stage].[fn_GetUTCDateTime](chg.AllocationDate, chg.[CenterID]) as 'HairSystemAllocationDate'
								, 0 AS [HairSystemReceivedDateKey]
								,[bief_stage].[fn_GetUTCDateTime](chg.ReceivedCorpDate, chg.[CenterID])	as 'HairSystemReceivedDate'
								, 0 AS [HairSystemShippedDateKey]
								,[bief_stage].[fn_GetUTCDateTime](chg.ShippedFromCorpDate, chg.[CenterID])	as 'HairSystemShippedDate'
								, 0 AS [HairSystemAppliedDateKey]
								,[bief_stage].[fn_GetUTCDateTime](chg.AppliedDate, chg.[CenterID])	as 'HairSystemAppliedDate'
								, 0 AS [CenterKey]
								, COALESCE(chg.[CenterID],-2) AS [CenterSSID]
								, 0 AS [ClientHomeCenterKey]
								, COALESCE(chg.[ClientHomeCenterID],-2) AS [ClientHomeCenterSSID]
								, 0 AS [ClientKey]
								, COALESCE(chg.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
								, 0 AS [ClientMembershipKey]
								, COALESCE(chg.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientMembershipSSID]
								, COALESCE(chg.[OriginalClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientSSID]
								, COALESCE(chg.[OriginalClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientMembershipSSID]
								, 0 AS [HairSystemHairLengthKey]
								, COALESCE(chg.[HairSystemHairLengthID], -1) AS [HairSystemHairLengthSSID]
								, 0 AS [HairSystemHairType]
								, COALESCE(chg.[HairSystemID], -1) AS [HairSystemTypeSSID]
								, 0 AS [HairSystemTextureKey]
								, COALESCE(chg.[HairSystemCurlID], -1) AS [HairSystemTextureSSID]
								, 0 AS [HairSystemMatrixColorKey]
								, COALESCE(chg.[HairSystemMatrixColorID], -1) AS [HairSystemMatrixColorSSID]
								, 0 AS [HairSystemDensityKey]
								, COALESCE(chg.[HairSystemDensityID], -1) AS [HairSystemDensitySSID]
								, 0 AS [HairSystemFrontalDensityKey]
								, COALESCE(chg.[HairSystemFrontalDensityID], -1) AS [HairSystemFrontalDensitySSID]
								, 0 AS [HairSystemStyleKey]
								, COALESCE(chg.[HairSystemStyleID], -1) AS [HairSystemStyleSSID]
								, 0 AS [HairSystemDesignTemplateKey]
								, COALESCE(chg.[HairSystemDesignTemplateID], -1) AS [HairSystemDesignTemplateSSID]
								, 0 AS [HairSystemRecessionKey]
								, COALESCE(chg.[HairSystemRecessionID], -1) AS [HairSystemRecessionSSID]
								, 0 AS [HairSystemTopHairColorKey]
								, COALESCE(chg.[ColorTopHairSystemHairColorID], -1) AS [HairSystemTopHairColorSSID]
								, 0 AS [MeasurementsByEmployee1Key]
								, COALESCE(chg.[MeasurementEmployeeGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [MeasurementsByEmployee1SSID]
								--, CASE WHEN chg.TemplateAreaActualCalc <= 80 THEN 3
								--		WHEN chg.TemplateAreaActualCalc > 80 AND chg.TemplateAreaActualCalc <= 110 THEN 4
								--		WHEN chg.TemplateAreaActualCalc > 110 THEN 5
								--		ELSE 6
								--	END	AS 'CapSizeKey'
								, CASE	WHEN	((ISNULL(chg.[TemplateWidth],(0.00))+ISNULL(chg.[TemplateWidthAdjustment],(0.00)))
											*(ISNULL(chg.[TemplateHeight],(0.00))+ISNULL(chg.[TemplateHeightAdjustment],(0.00))))	<= 80 THEN 3

										WHEN	((ISNULL(chg.[TemplateWidth],(0.00))+ISNULL(chg.[TemplateWidthAdjustment],(0.00)))
											*(ISNULL(chg.[TemplateHeight],(0.00))+ISNULL(chg.[TemplateHeightAdjustment],(0.00))))	> 80 AND
											((ISNULL(chg.[TemplateWidth],(0.00))+ISNULL(chg.[TemplateWidthAdjustment],(0.00)))
											*(ISNULL(chg.[TemplateHeight],(0.00))+ISNULL(chg.[TemplateHeightAdjustment],(0.00))))	<= 110 THEN 4

										WHEN	((ISNULL(chg.[TemplateWidth],(0.00))+ISNULL(chg.[TemplateWidthAdjustment],(0.00)))
											*(ISNULL(chg.[TemplateHeight],(0.00))+ISNULL(chg.[TemplateHeightAdjustment],(0.00))))	> 110 THEN 5
									ELSE 6
									END AS 'CapSizeKey'
								--, COALESCE(chg.TemplateWidthActualCalc,0) as 'TemplateWidth'
								, (ISNULL(chg.[TemplateWidth],(0.00))+ISNULL(chg.[TemplateWidthAdjustment],(0.00))) as 'TemplateWidth'
								--, COALESCE(chg.TemplateHeightActualCalc,0) as 'TemplateHeight'
								, (ISNULL(chg.[TemplateHeight],(0.00))+ISNULL(chg.[TemplateHeightAdjustment],(0.00))) as 'TemplateHeight'
								--, COALESCE(chg.TemplateAreaActualCalc,0) as 'TemplateArea'
								, ((ISNULL(chg.[TemplateWidth],(0.00))+ISNULL(chg.[TemplateWidthAdjustment],(0.00)))
									*(ISNULL(chg.[TemplateHeight],(0.00))+ISNULL(chg.[TemplateHeightAdjustment],(0.00)))) as 'TemplateArea'
								, 0 AS [HairSystemVendorContractKey]
								, COALESCE(vcp.[HairSystemVendorContractID], -2) AS [HairSystemVendorContractSSID]
								, ISNULL(VN.VendorDescriptionShort, 'NotAllocated') -- FactorySSID
								, 0 AS [HairSystemOrderStatusKey]
								, COALESCE(chg.[HairSystemOrderStatusID], -1) AS [HairSystemOrderStatusSSID]
								, COALESCE(chg.CostContract,0) as 'CostContract'
								, COALESCE(chg.CostActual,0) as 'CostActual'
								, COALESCE(chg.CenterPrice,0) as 'PriceContract'
								, chg.HairSystemRepairReasonID as 'HairSystemRepairReasonSSID'
								, repair.HairSystemRepairReasonDescription as 'HairSystemRepairReasonDescription'
								, chg.HairSystemRedoReasonID as 'HairSystemRedoReasonID'
								, redo.HairSystemRedoReasonDescription as 'HairSystemRedoReasonDescription'
								, CAST(IsOnHoldForReviewFlag AS INT) as 'IsOnHoldForReviewFlag'
								, CAST(chg.IsSampleOrderFlag AS INT) AS 'IsSampleOrder'
								, CAST(chg.IsRepairOrderFlag AS INT) AS 'IsRepairOrder'
								, CAST(chg.IsRedoOrderFlag AS INT) AS 'IsRedoOrder'
								, CAST(chg.IsRushOrderFlag AS INT) AS 'IsRushOrder'
								, CAST(chg.IsStockInventoryFlag AS INT) AS 'IsStockInventory'
								, 0 AS [IsException]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.hairsystemorderguid)),'') AS nvarchar(50)) AS [SourceSystemKey]
							FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datHairSystemOrder](@From_LSN, @To_LSN, @row_filter_option) chg
								 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgHairSystemVendorContractPricing vcp with (nolock) ON
									chg.HairSystemVendorContractPricingID = vcp.HairSystemVendorContractPricingID
								 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgHairSystemVendorContract vc with (nolock) ON
									vcp.HairSystemVendorContractID = vc.HairSystemVendorContractID
								 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgVendor vn with (nolock) ON
									vc.vendorid = vn.vendorid
								 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpHairSystemRepairReason repair with (nolock) ON
									chg.HairSystemRepairReasonID = repair.HairSystemRepairReasonID
								 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpHairSystemRedoReason Redo with (nolock) ON
									chg.HairSystemRedoReasonID = redo.HairSystemRedoReasonID
								 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_datClientMembership clm with (nolock) ON
									chg.ClientMembershipGUID = clm.ClientMembershipGUID

							SET @ExtractRowCnt = @@ROWCOUNT

							-- Set the Last Successful Extraction Time & Status
							UPDATE [bief_stage].[_DataFlow]
								SET LSET = @CET
									, [Status] = 'Extraction Completed'
								WHERE [TableName] = @TableName

					END
		END

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt

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
