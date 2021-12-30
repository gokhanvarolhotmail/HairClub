/* CreateDate: 10/26/2011 12:15:02.560 , ModifyDate: 11/06/2012 10:38:30.773 */
GO
CREATE TABLE [bi_cms_stage].[FactHairSystemOrder](
	[DataPkgKey] [int] NOT NULL,
	[HairSystemOrderKey] [int] NULL,
	[HairSystemOrderSSID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [int] NULL,
	[HairSystemOrderDateKey] [int] NULL,
	[HairSystemOrderDate] [datetime] NULL,
	[HairSystemDueDateKey] [int] NULL,
	[HairSystemDueDate] [datetime] NULL,
	[HairSystemAllocationDateKey] [int] NULL,
	[HairSystemAllocationDate] [datetime] NULL,
	[HairSystemReceivedDateKey] [int] NULL,
	[HairSystemReceivedDate] [datetime] NULL,
	[HairSystemShippedDateKey] [int] NULL,
	[HairSystemShippedDate] [datetime] NULL,
	[HairSystemAppliedDateKey] [int] NULL,
	[HairSystemAppliedDate] [datetime] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[OrigClientSSID] [uniqueidentifier] NULL,
	[OrigClientMembershipSSID] [uniqueidentifier] NULL,
	[HairSystemHairLengthKey] [int] NULL,
	[HairSystemHairLengthSSID] [int] NULL,
	[HairSystemTypeKey] [int] NULL,
	[HairSystemTypeSSID] [int] NULL,
	[HairSystemTextureKey] [int] NULL,
	[HairSystemTextureSSID] [int] NULL,
	[HairSystemMatrixColorKey] [int] NULL,
	[HairSystemMatrixColorSSID] [int] NULL,
	[HairSystemDensityKey] [int] NULL,
	[HairSystemDensitySSID] [int] NULL,
	[HairSystemFrontalDensityKey] [int] NULL,
	[HairSystemFrontalDensitySSID] [int] NULL,
	[HairSystemStyleKey] [int] NULL,
	[HairSystemStyleSSID] [int] NULL,
	[HairSystemDesignTemplateKey] [int] NULL,
	[HairSystemDesignTemplateSSID] [int] NULL,
	[HairSystemRecessionKey] [int] NULL,
	[HairSystemRecessionSSID] [int] NULL,
	[HairSystemTopHairColorKey] [int] NULL,
	[HairSystemTopHairColorSSID] [int] NULL,
	[MeasurementsByEmployeeKey] [int] NULL,
	[MeasurementsByEmployeeSSID] [uniqueidentifier] NULL,
	[CapSizeKey] [int] NULL,
	[TemplateWidth] [decimal](10, 4) NULL,
	[TemplateHeight] [decimal](10, 4) NULL,
	[TemplateArea] [decimal](21, 6) NULL,
	[HairSystemVendorContractKey] [int] NULL,
	[HairSystemVendorContractSSID] [int] NULL,
	[FactorySSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderStatusKey] [int] NULL,
	[HairSystemOrderStatusSSID] [int] NULL,
	[CostContract] [decimal](21, 6) NULL,
	[CostActual] [decimal](21, 6) NULL,
	[PriceContract] [decimal](21, 6) NULL,
	[HairSystemRepairReasonSSID] [int] NULL,
	[HairSystemRepairReasonDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemRedoReasonSSID] [int] NULL,
	[HairSystemRedoReasonDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsOnHoldForReviewFlag] [bit] NOT NULL,
	[IsSampleOrderFlag] [int] NOT NULL,
	[IsRepairOrderFlag] [int] NOT NULL,
	[IsRedoOrderFlag] [int] NOT NULL,
	[IsRushOrderFlag] [int] NOT NULL,
	[IsStockInventoryFlag] [int] NOT NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientHomeCenterKey] [int] NULL,
	[ClientHomeCenterSSID] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactHairSystemOrder_DataPkgKey] ON [bi_cms_stage].[FactHairSystemOrder]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsSampleOrderFlag]  DEFAULT ((0)) FOR [IsSampleOrderFlag]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsRepairOrderFlag]  DEFAULT ((0)) FOR [IsRepairOrderFlag]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsRedoOrderFlag]  DEFAULT ((0)) FOR [IsRedoOrderFlag]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsRushOrderFlag]  DEFAULT ((0)) FOR [IsRushOrderFlag]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsStockInventoryFlag]  DEFAULT ((0)) FOR [IsStockInventoryFlag]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
