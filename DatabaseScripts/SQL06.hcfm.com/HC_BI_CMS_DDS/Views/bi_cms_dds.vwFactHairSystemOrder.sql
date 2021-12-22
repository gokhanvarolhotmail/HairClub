/* CreateDate: 10/03/2019 23:03:43.970 , ModifyDate: 10/02/2020 10:53:49.770 */
GO
CREATE VIEW [bi_cms_dds].[vwFactHairSystemOrder] AS
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
--			10/02/2020  KMurdoch     Restricted to 2017 forward
-------------------------------------------------------------------------
SELECT	DD.[FullDate] AS [PartitionDate]
	  ,	DD.[FullDate] AS [OrderDate]
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
	  ,ISNULL(DG.[GenderKey],-1) AS [GenderKey]
	  ,DG.GenderDescription AS [GenderDescription]
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
      ,DATEDIFF(DAY,ISNULL(HSO.HairSystemAlocationDate,HSO.HairSystemOrderDate),HSO.HairSystemReceivedDate) AS 'DaystoDelivery'
	  ,CASE WHEN [HairSystemReceivedDate] IS NULL AND hso.HairSystemOrderStatusKey IN (16,19,8,22) THEN DATEDIFF(DAY,HSO.HairSystemAlocationDate,GETDATE())
			ELSE DATEDIFF(DAY,ISNULL(HSO.HairSystemAlocationDate,HSO.HairSystemOrderDate),HSO.HairSystemReceivedDate) END AS 'DaysSinceAllocation'
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
	  ,1 AS 'OrderCount'

  FROM [HC_BI_CMS_DDS].[bi_cms_dds].[FactHairSystemOrder] HSO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.vwDimHairSystemOrderStatus STAT ON
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
		ON DCM.MembershipKey = DMEM.MembershipKey

WHERE HairSystemOrderDate >= '01/01/2017'
GO
