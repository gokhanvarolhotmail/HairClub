/* CreateDate: 06/27/2011 16:35:34.113 , ModifyDate: 09/16/2019 09:33:49.900 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwFactHairSystemOrder]
AS
-------------------------------------------------------------------------
-- [vwFactHairSystemOrder] is used to retrieve a
-- list of Hair System Order Records
--
--   SELECT * FROM [bi_cms_dds].[vwFactHairSystemOrder]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/24/2011  KMurdoch     Initial Creation
--			12/05/2012  KMurdoch     Added GenderKey
-------------------------------------------------------------------------
SELECT	DD.[FullDate] AS [PartitionDate]
	  ,	DD.[FullDate] as [OrderDate]
	  ,	[HairSystemOrderKey]
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
      ,HSO.[CenterKey]
	  ,[ClientHomeCenterKey]
      ,HSO.[ClientKey]
      ,HSO.[ClientMembershipKey]
	  ,DMEM.[MembershipKey]
	  ,ISNULL(DG.[GenderKey],-1) as [GenderKey]
	  ,DG.GenderDescription as [GenderDescription]
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
      ,DATEDIFF(DAY,ISNULL(HSO.HairSystemAlocationDate,HSO.HairSystemOrderDate),HSO.HairSystemReceivedDate) as 'DaystoDelivery'
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
      ,HSO.[InsertAuditKey]
      ,HSO.[UpdateAuditKey]
	  ,1 as 'OrderCount'

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactHairSystemOrder] HSO
	inner join HC_BI_CMS_DDS.bi_cms_dds.vwDimHairSystemOrderStatus STAT on
		HSO.HairSystemOrderStatusKey = STAT.HairSystemOrderStatusKey
	LEFT OUTER JOIN  [bi_cms_dds].[synHC_ENT_DDS_DimDate] DD
		ON HSO.[HairSystemOrderDateKey] = DD.[DateKey]
	LEFT OUTER JOIN  [bi_cms_dds].[DimClient] DC
		ON HSO.[ClientKey] = DC.[ClientKey]
	LEFT OUTER JOIN  [HC_BI_ENT_DDS].[bi_ent_dds].[DimGender] DG
		ON DC.[GenderSSID] = DG.[GenderKey]
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimClientMembership] DCM
		ON HSO.ClientMembershipKey = DCM.ClientMembershipKey
	INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] DMEM
		on DCM.MembershipKey = DMEM.MembershipKey
GO
