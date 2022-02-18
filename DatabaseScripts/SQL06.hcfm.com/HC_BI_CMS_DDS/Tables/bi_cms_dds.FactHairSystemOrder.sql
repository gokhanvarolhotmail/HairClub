/* CreateDate: 10/03/2019 23:03:42.283 , ModifyDate: 02/17/2022 08:13:30.570 */
GO
CREATE TABLE [bi_cms_dds].[FactHairSystemOrder](
	[HairSystemOrderKey] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactHairSystemOrder_ClientKey_HairSystemAppliedDate] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[ClientKey] ASC,
	[HairSystemAppliedDate] ASC
)
INCLUDE([HairSystemOrderNumber],[HairSystemOrderDate],[HairSystemDueDate],[CenterKey],[ClientMembershipKey],[ClientHomeCenterKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [NCI_FHSO_HSOD] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderNumber],[HairSystemOrderDateKey],[HairSystemDueDate],[HairSystemAlocationDate],[HairSystemReceivedDate],[HairSystemShippedDate],[HairSystemAppliedDate],[CenterKey],[ClientKey],[ClientMembershipKey],[HairSystemTypeKey],[HairSystemDesignTemplateKey],[CapSizeKey],[TemplateWidth],[TemplateHeight],[TemplateArea],[FactorySSID],[HairSystemOrderStatusKey],[CostContract],[CostActual],[PriceContract],[HairSystemRepairReasonDescription],[HairSystemRedoReasonDescription],[IsOnHoldForReviewFlag],[IsSampleOrderFlag],[IsRepairOrderFlag],[IsRedoOrderFlag],[IsRushOrderFlag],[IsStockInventoryFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [NCI_FHSO_HSODK_HSOD] ON [bi_cms_dds].[FactHairSystemOrder]
(
	[HairSystemOrderDateKey] ASC,
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderNumber],[HairSystemDueDate],[HairSystemAlocationDate],[HairSystemReceivedDate],[HairSystemShippedDate],[HairSystemAppliedDate],[CenterKey],[ClientKey],[ClientMembershipKey],[HairSystemTypeKey],[HairSystemDesignTemplateKey],[CapSizeKey],[TemplateWidth],[TemplateHeight],[TemplateArea],[FactorySSID],[HairSystemOrderStatusKey],[CostContract],[CostActual],[PriceContract],[HairSystemRepairReasonDescription],[HairSystemRedoReasonDescription],[IsOnHoldForReviewFlag],[IsSampleOrderFlag],[IsRepairOrderFlag],[IsRedoOrderFlag],[IsRushOrderFlag],[IsStockInventoryFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
