/* CreateDate: 03/17/2022 11:57:11.890 , ModifyDate: 03/17/2022 11:57:11.890 */
GO
CREATE VIEW [bi_cms_dds].[vwDimHairSystemOrder]
AS
-------------------------------------------------------------------------
-- [vwDimHairSystemOrder] is used to retrieve a
-- list of Hair System Order Records
--
--   SELECT * FROM [bi_cms_dds].[vwDimHairSystemOrder]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
--			11/06/2012  KMurdoch	 Added ClientHomeCenterKey
-------------------------------------------------------------------------
SELECT [HairSystemOrderKey]
      ,[HairSystemOrderSSID]
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
      ,HSO.[HairSystemOrderStatusKey]
      ,[CostContract]
      ,[CostActual]
      ,[PriceContract]
      ,[HairSystemRepairReasonSSID]
      ,[HairSystemRepairReasonDescription]
      ,[HairSystemRedoReasonSSID]
      ,[HairSystemRedoReasonDescription]
      , CASE WHEN [FactorySSID] <> 'NotAllocat' then 1 else 0 end as 'IsAllocatedFlag'
      , CASE WHEN [STAT].HairSystemOrderStatusDescriptionShort = 'CANCEL' then 1 else 0 end as 'IsCancelledFlag'
      , CASE WHEN [FactorySSID] <> 'NotAllocat' and CostContract = 0 THEN 1 ELSE 0 end 'IsZeroCostFlag'
      , CASE WHEN [FactorySSID] <> 'NotAllocat' and PriceContract = 0 THEN 1 ELSE 0 end 'IsZeroPriceFlag'
      ,cast([IsOnHoldForReviewFlag] as int) 'IsOnHoldForReviewFlag'
      ,[IsSampleOrderFlag]
      ,[IsRepairOrderFlag]
      ,[IsRedoOrderFlag]
      ,[IsRushOrderFlag]
      ,[IsStockInventoryFlag]
      ,[InsertAuditKey]
      ,[UpdateAuditKey]

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactHairSystemOrder] HSO
	inner join HC_BI_CMS_DDS.bi_cms_dds.vwDimHairSystemOrderStatus STAT on
		HSO.HairSystemOrderStatusKey = STAT.HairSystemOrderStatusKey
GO
