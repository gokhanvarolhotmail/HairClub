/* CreateDate: 06/27/2011 17:23:51.720 , ModifyDate: 01/03/2013 14:57:00.577 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Extract]  '2011-01-01 01:00:00'
--                                       , '2011-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/09/2011  KMurdoch     Initial Creation
--			09/07/2011	KMurdoch	 Modified calculcated columns
--			09/20/2011  KMurdoch	 Changed center derivation to Client Home Center
--			11/06/2012	KMurdoch	 Added ClientHomeCenter; changed derivation back to Center
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
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
				, @ExtractRowCnt		int
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[FactHairSystemOrder]'


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

				-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = @CET
						, [Status] = 'Extracting'
					WHERE [TableName] = @TableName

				-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [HC_BI_CMS_STAGE].[bi_cms_stage].[FactHairSystemOrder]
						   ([DataPkgKey]
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

				SELECT
							@DataPkgKey
							, NULL AS [HairSystemOrderKey]
							, COALESCE(hso.[HairSystemOrderGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [HairSystemOrderSSID]
							, hso.HairSystemOrderNumber as [HairSystemOrderNumber]
							, 0 AS [HairSystemOrderDateKey]
							, hso.HairSystemOrderDate as 'HairSystemOrderDate'
							, 0 AS [HairSystemDueDateKey]
							, hso.DueDate as 'HairSystemDueDate'
							, 0 AS [HairSystemAllocationDateKey]
							, [bief_stage].[fn_GetUTCDateTime](hso.AllocationDate, hso.[CenterID]) as 'HairSystemAllocationDate'
							, 0 AS [HairSystemReceivedDateKey]
							,[bief_stage].[fn_GetUTCDateTime](hso.ReceivedCorpDate, hso.[CenterID])	as 'HairSystemReceivedDate'
							, 0 AS [HairSystemShippedDateKey]
							,[bief_stage].[fn_GetUTCDateTime](hso.ShippedFromCorpDate, hso.[CenterID])	as 'HairSystemShippedDate'
							, 0 AS [HairSystemAppliedDateKey]
							,[bief_stage].[fn_GetUTCDateTime](hso.AppliedDate, hso.[CenterID])	as 'HairSystemAppliedDate'
							, 0 AS [CenterKey]
							, COALESCE(hso.[CenterID],-2) AS [CenterSSID]
							, 0 AS [ClientHomeCenterKey]
							, COALESCE(hso.[ClientHomeCenterID],-2) AS [ClientHomeCenterSSID]
							, 0 AS [ClientKey]
							, COALESCE(hso.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
							--, 0 AS [MembershipKey]
							, 0 AS [ClientMembershipKey]
							, COALESCE(hso.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientMembershipSSID]
							--, 0 AS [OrigClientKey]
							, COALESCE(hso.[OriginalClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientSSID]
							--, 0 AS [OrigMembershipKey]
							--, 0 AS [OrigClientMembershipKey]
							, COALESCE(hso.[OriginalClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientMembershipSSID]
							, 0 AS [HairSystemHairLengthKey]
							, COALESCE(hso.[HairSystemHairLengthID], -1) AS [HairSystemHairLengthSSID]
							, 0 AS [HairSystemHairType]
							, COALESCE(hso.[HairSystemID], -1) AS [HairSystemTypeSSID]
							, 0 AS [HairSystemTextureKey]
							, COALESCE(hso.[HairSystemCurlID], -1) AS [HairSystemTextureSSID]
							, 0 AS [HairSystemMatrixColorKey]
							, COALESCE(hso.[HairSystemMatrixColorID], -1) AS [HairSystemMatrixColorSSID]
							, 0 AS [HairSystemDensityKey]
							, COALESCE(hso.[HairSystemDensityID], -1) AS [HairSystemDensitySSID]
							, 0 AS [HairSystemFrontalDensityKey]
							, COALESCE(hso.[HairSystemFrontalDensityID], -1) AS [HairSystemFrontalDensitySSID]
							, 0 AS [HairSystemStyleKey]
							, COALESCE(hso.[HairSystemStyleID], -1) AS [HairSystemStyleSSID]
							, 0 AS [HairSystemDesignTemplateKey]
							, COALESCE(hso.[HairSystemDesignTemplateID], -1) AS [HairSystemDesignTemplateSSID]
							, 0 AS [HairSystemRecessionKey]
							, COALESCE(hso.[HairSystemRecessionID], -1) AS [HairSystemRecessionSSID]
							, 0 AS [HairSystemTopHairColorKey]
							, COALESCE(hso.[ColorTopHairSystemHairColorID], -1) AS [HairSystemTopHairColorSSID]
							, 0 AS [MeasurementsByEmployee1Key]
							, COALESCE(hso.[MeasurementEmployeeGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [MeasurementsByEmployee1SSID]
							--, CASE WHEN hso.TemplateAreaActualCalc <= 80 THEN 3
							--		WHEN hso.TemplateAreaActualCalc > 80 AND TemplateAreaActualCalc <= 110 THEN 4
							--		WHEN hso.TemplateAreaActualCalc > 110 THEN 5
							--		ELSE 6
							--	END	AS 'CapSizeKey'
							, CASE	WHEN	((isnull(hso.[TemplateWidth],(0.00))+isnull(hso.[TemplateWidthAdjustment],(0.00)))
								*(isnull(hso.[TemplateHeight],(0.00))+isnull(hso.[TemplateHeightAdjustment],(0.00))))	<= 80 THEN 3

									WHEN	((isnull(hso.[TemplateWidth],(0.00))+isnull(hso.[TemplateWidthAdjustment],(0.00)))
								*(isnull(hso.[TemplateHeight],(0.00))+isnull(hso.[TemplateHeightAdjustment],(0.00))))	> 80 AND
									((isnull(hso.[TemplateWidth],(0.00))+isnull(hso.[TemplateWidthAdjustment],(0.00)))
								*(isnull(hso.[TemplateHeight],(0.00))+isnull(hso.[TemplateHeightAdjustment],(0.00))))	<= 110 THEN 4

									WHEN	((isnull(hso.[TemplateWidth],(0.00))+isnull(hso.[TemplateWidthAdjustment],(0.00)))
								*(isnull(hso.[TemplateHeight],(0.00))+isnull(hso.[TemplateHeightAdjustment],(0.00))))	> 110 THEN 5
									ELSE 6
								END AS 'CapSizeKey'
							--, COALESCE(hso.TemplateWidthActualCalc,0) as 'TemplateWidth'
							, (ISNULL(hso.[TemplateWidth],(0.00))+ISNULL(hso.[TemplateWidthAdjustment],(0.00))) as 'TemplateWidth'
							--, COALESCE(hso.TemplateHeightActualCalc,0) as 'TemplateHeight'
							, (ISNULL(hso.[TemplateHeight],(0.00))+ISNULL(hso.[TemplateHeightAdjustment],(0.00))) as 'TemplateHeight'
							--, COALESCE(hso.TemplateAreaActualCalc,0) as 'TemplateArea'
							, ((isnull(hso.[TemplateWidth],(0.00))+isnull(hso.[TemplateWidthAdjustment],(0.00)))
								*(isnull(hso.[TemplateHeight],(0.00))+isnull(hso.[TemplateHeightAdjustment],(0.00)))) as 'TemplateArea'
							, 0 AS [HairSystemVendorContractKey]
							, COALESCE(vcp.[HairSystemVendorContractID], -2) AS [HairSystemVendorContractSSID]
							, ISNULL(VN.VendorDescriptionShort, 'NotAllocated') -- FactorySSID
							, 0 AS [HairSystemOrderStatusKey]
							, COALESCE(hso.[HairSystemOrderStatusID], -1) AS [HairSystemOrderStatusSSID]
							, COALESCE(hso.CostContract,0) as 'CostContract'
							, COALESCE(hso.CostActual,0) as 'CostActual'
							, COALESCE(hso.CenterPrice,0) as 'PriceContract'
							, hso.HairSystemRepairReasonID as 'HairSystemRepairReasonSSID'
							, repair.HairSystemRepairReasonDescription as 'HairSystemRepairReasonDescription'
							, hso.HairSystemRedoReasonID as 'HairSystemRedoReasonID'
							, redo.HairSystemRedoReasonDescription as 'HairSystemRedoReasonDescription'
							, CAST(IsOnHoldForReviewFlag AS INT) as 'IsOnHoldForReviewFlag'
							, CAST(hso.IsSampleOrderFlag AS INT) AS 'IsSampleOrder'
							, CAST(hso.IsRepairOrderFlag AS INT) AS 'IsRepairOrder'
							, CAST(hso.IsRedoOrderFlag AS INT) AS 'IsRedoOrder'
							, CAST(hso.IsRushOrderFlag AS INT) AS 'IsRushOrder'
							, CAST(hso.IsStockInventoryFlag AS INT) AS 'IsStockInventory'
							, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(hso.hairsystemorderguid)),'') AS nvarchar(50)) AS [SourceSystemKey]
						FROM  bi_cms_stage.synHC_SRC_TBL_CMS_datHairSystemOrder hso
							 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgHairSystemVendorContractPricing vcp ON
								hso.HairSystemVendorContractPricingID = vcp.HairSystemVendorContractPricingID
							 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgHairSystemVendorContract vc on
								vcp.HairSystemVendorContractID = vc.HairSystemVendorContractID
							 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgVendor vn on
								vc.vendorid = vn.vendorid
							 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpHairSystemRepairReason repair ON
								hso.HairSystemRepairReasonID = repair.HairSystemRepairReasonID
							 LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpHairSystemRedoReason Redo on
								hso.HairSystemRedoReasonID = redo.HairSystemRedoReasonID
				WHERE (hso.[CreateDate] >= @LSET AND hso.[CreateDate] < @CET_UTC)
				   OR (hso.[LastUpdate] >= @LSET AND hso.[LastUpdate] < @CET_UTC)

				SET @ExtractRowCnt = @@ROWCOUNT

				-- Set the Last Successful Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET LSET = @CET
						, [Status] = 'Extraction Completed'
					WHERE [TableName] = @TableName
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
