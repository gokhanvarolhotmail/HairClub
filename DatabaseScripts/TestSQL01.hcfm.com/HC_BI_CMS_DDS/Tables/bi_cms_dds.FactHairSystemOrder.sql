/* CreateDate: 06/27/2011 16:01:43.487 , ModifyDate: 09/16/2019 09:33:50.103 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[FactHairSystemOrder](
	[HairSystemOrderKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemOrderSSID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [int] NULL,
	[HairSystemOrderDateKey] [int] NULL,
	[HairSystemOrderDate] [datetime] NULL,
	[HairSystemDueDateKey] [int] NULL,
	[HairSystemDueDate] [datetime] NULL,
	[HairSystemAllocationDateKey] [int] NULL,
	[HairSystemAlocationDate] [datetime] NULL,
	[HairSystemReceivedDateKey] [int] NULL,
	[HairSystemReceivedDate] [datetime] NULL,
	[HairSystemShippedDateKey] [int] NULL,
	[HairSystemShippedDate] [datetime] NULL,
	[HairSystemAppliedDateKey] [int] NULL,
	[HairSystemAppliedDate] [datetime] NULL,
	[CenterKey] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[OrigClientSSID] [uniqueidentifier] NULL,
	[OrigClientMembershipSSID] [uniqueidentifier] NULL,
	[HairSystemHairLengthKey] [int] NULL,
	[HairSystemTypeKey] [int] NULL,
	[HairSystemTextureKey] [int] NULL,
	[HairSystemMatrixColorKey] [int] NULL,
	[HairSystemDensityKey] [int] NULL,
	[HairSystemFrontalDensityKey] [int] NULL,
	[HairSystemStyleKey] [int] NULL,
	[HairSystemDesignTemplateKey] [int] NULL,
	[HairSystemRecessionKey] [int] NULL,
	[HairSystemTopHairColorKey] [int] NULL,
	[MeasurementsByEmployeeKey] [int] NULL,
	[CapSizeKey] [int] NULL,
	[TemplateWidth] [decimal](10, 4) NULL,
	[TemplateHeight] [decimal](10, 4) NULL,
	[TemplateArea] [decimal](21, 6) NULL,
	[HairSystemVendorContractKey] [int] NULL,
	[FactorySSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderStatusKey] [int] NULL,
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
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[ClientHomeCenterKey] [int] NULL,
 CONSTRAINT [PK_FactHairSystemOrder] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactHairSystemOrder_ClientKey] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[ClientKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactHairSystemOrder_INCL2] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[HairSystemOrderKey] ASC
)
INCLUDE([HairSystemHairLengthKey],[HairSystemMatrixColorKey],[HairSystemDensityKey],[HairSystemFrontalDensityKey],[HairSystemStyleKey],[HairSystemDesignTemplateKey],[HairSystemRecessionKey],[HairSystemTopHairColorKey],[MeasurementsByEmployeeKey],[CapSizeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactHairSystemOrderKey_INCL] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[HairSystemOrderKey] ASC
)
INCLUDE([HairSystemOrderDateKey],[HairSystemDueDateKey],[HairSystemAllocationDateKey],[HairSystemReceivedDateKey],[HairSystemShippedDateKey],[HairSystemAppliedDateKey],[CenterKey],[ClientKey],[ClientMembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Temp_FactHairSystemOrder_ClientMembershipKey] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_cms_dds].[FactHairSystemOrder] ADD  CONSTRAINT [DF_FactHairSystemOrder_MSrepl_tran_version]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
