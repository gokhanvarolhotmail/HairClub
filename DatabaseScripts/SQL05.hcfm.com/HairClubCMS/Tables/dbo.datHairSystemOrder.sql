/* CreateDate: 05/05/2020 17:42:46.437 , ModifyDate: 01/27/2022 19:34:52.217 */
GO
CREATE TABLE [dbo].[datHairSystemOrder](
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[ClientHomeCenterID] [int] NOT NULL,
	[HairSystemOrderStatusID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[OriginalClientGUID] [uniqueidentifier] NULL,
	[OriginalClientMembershipGUID] [uniqueidentifier] NULL,
	[HairSystemOrderDate] [datetime] NOT NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MeasurementEmployeeGUID] [uniqueidentifier] NULL,
	[DueDate] [datetime] NULL,
	[TemplateReceivedDate] [datetime] NULL,
	[AppliedDate] [datetime] NULL,
	[IsRepairOrderFlag] [bit] NULL,
	[IsRedoOrderFlag] [bit] NULL,
	[IsRushOrderFlag] [bit] NULL,
	[IsStockInventoryFlag] [bit] NULL,
	[IsOnCenterHoldFlag] [bit] NULL,
	[OriginalHairSystemOrderGUID] [uniqueidentifier] NULL,
	[TemplateWidth] [decimal](10, 4) NULL,
	[TemplateWidthAdjustment] [decimal](10, 4) NULL,
	[TemplateWidthActualCalc]  AS (isnull([TemplateWidth],(0.00))+isnull([TemplateWidthAdjustment],(0.00))),
	[TemplateHeight] [decimal](10, 4) NULL,
	[TemplateHeightAdjustment] [decimal](10, 4) NULL,
	[TemplateHeightActualCalc]  AS (isnull([TemplateHeight],(0.00))+isnull([TemplateHeightAdjustment],(0.00))),
	[TemplateAreaActualCalc]  AS ((isnull([TemplateWidth],(0.00))+isnull([TemplateWidthAdjustment],(0.00)))*(isnull([TemplateHeight],(0.00))+isnull([TemplateHeightAdjustment],(0.00)))),
	[HairSystemOrderSpecialInstructionID] [int] NULL,
	[HairSystemID] [int] NULL,
	[HairSystemMatrixColorID] [int] NULL,
	[HairSystemDesignTemplateID] [int] NULL,
	[HairSystemRecessionID] [int] NULL,
	[HairSystemDensityID] [int] NULL,
	[HairSystemFrontalDensityID] [int] NULL,
	[HairSystemHairLengthID] [int] NULL,
	[HairSystemFrontalDesignID] [int] NULL,
	[HairSystemCurlID] [int] NULL,
	[HairSystemStyleID] [int] NULL,
	[ColorHairSystemHairMaterialID] [int] NULL,
	[ColorFrontHairSystemHairColorID] [int] NULL,
	[ColorTempleHairSystemHairColorID] [int] NULL,
	[ColorTopHairSystemHairColorID] [int] NULL,
	[ColorSidesHairSystemHairColorID] [int] NULL,
	[ColorCrownHairSystemHairColorID] [int] NULL,
	[ColorBackHairSystemHairColorID] [int] NULL,
	[Highlight1HairSystemHairMaterialID] [int] NULL,
	[Highlight1HairSystemHighlightID] [int] NULL,
	[Highlight1FrontHairSystemHairColorID] [int] NULL,
	[Highlight1TempleHairSystemHairColorID] [int] NULL,
	[Highlight1TopHairSystemHairColorID] [int] NULL,
	[Highlight1SidesHairSystemHairColorID] [int] NULL,
	[Highlight1CrownHairSystemHairColorID] [int] NULL,
	[Highlight1BackHairSystemHairColorID] [int] NULL,
	[Highlight1FrontHairSystemColorPercentageID] [int] NULL,
	[Highlight1TempleHairSystemColorPercentageID] [int] NULL,
	[Highlight1TopHairSystemColorPercentageID] [int] NULL,
	[Highlight1SidesHairSystemColorPercentageID] [int] NULL,
	[Highlight1CrownHairSystemColorPercentageID] [int] NULL,
	[Highlight1BackHairSystemColorPercentageID] [int] NULL,
	[Highlight2HairSystemHairMaterialID] [int] NULL,
	[Highlight2HairSystemHighlightID] [int] NULL,
	[Highlight2FrontHairSystemHairColorID] [int] NULL,
	[Highlight2TempleHairSystemHairColorID] [int] NULL,
	[Highlight2TopHairSystemHairColorID] [int] NULL,
	[Highlight2SidesHairSystemHairColorID] [int] NULL,
	[Highlight2CrownHairSystemHairColorID] [int] NULL,
	[Highlight2BackHairSystemHairColorID] [int] NULL,
	[Highlight2FrontHairSystemColorPercentageID] [int] NULL,
	[Highlight2TempleHairSystemColorPercentageID] [int] NULL,
	[Highlight2TopHairSystemColorPercentageID] [int] NULL,
	[Highlight2SidesHairSystemColorPercentageID] [int] NULL,
	[Highlight2CrownHairSystemColorPercentageID] [int] NULL,
	[Highlight2BackHairSystemColorPercentageID] [int] NULL,
	[GreyHairSystemHairMaterialID] [int] NULL,
	[GreyFrontHairSystemColorPercentageID] [int] NULL,
	[GreyTempleHairSystemColorPercentageID] [int] NULL,
	[GreyTopHairSystemColorPercentageID] [int] NULL,
	[GreySidesHairSystemColorPercentageID] [int] NULL,
	[GreyCrownHairSystemColorPercentageID] [int] NULL,
	[GreyBackHairSystemColorPercentageID] [int] NULL,
	[CostContract] [money] NOT NULL,
	[CostActual] [money] NOT NULL,
	[CenterPrice] [money] NOT NULL,
	[HairSystemVendorContractPricingID] [int] NULL,
	[CenterUseFromBridgeDistance] [decimal](10, 4) NULL,
	[CenterUseIsPermFlag] [bit] NOT NULL,
	[HairSystemRepairReasonID] [int] NULL,
	[HairSystemRedoReasonID] [int] NULL,
	[FactoryNote] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL,
	[HairSystemCenterContractPricingID] [int] NULL,
	[ManualVendorID] [int] NULL,
	[OrderedByEmployeeGUID] [uniqueidentifier] NULL,
	[HairSystemHoldReasonID] [int] NULL,
	[HairSystemFactoryNoteID] [int] NULL,
	[HairSystemFrontalLaceLengthID] [int] NULL,
	[HairSystemLocationID] [int] NULL,
	[IsOnHoldForReviewFlag] [bit] NOT NULL,
	[IsSampleOrderFlag] [bit] NOT NULL,
	[RequestForCreditAcceptedDate] [datetime] NULL,
	[RequestForCreditDeclinedDate] [datetime] NULL,
	[AllocationDate] [datetime] NULL,
	[ChargeDecisionID] [int] NULL,
	[ReceivedCorpDate] [datetime] NULL,
	[ShippedFromCorpDate] [datetime] NULL,
	[SubFactoryCode] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PodCode] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CostFactoryShipped] [money] NOT NULL,
	[FactoryShippedHairSystemVendorContractPricingID] [int] NULL,
	[IsFashionHairlineHighlightsFlag] [bit] NOT NULL,
	[VendorHairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSignatureHairlineAddOn] [bit] NOT NULL,
	[IsOmbreAddOn] [bit] NOT NULL,
	[IsExtendedLaceAddOn] [bit] NOT NULL,
	[IsLongHairAddOn] [bit] NOT NULL,
	[IsCuticleIntactHairAddOn] [bit] NOT NULL,
	[IsRootShadowingAddOn] [bit] NOT NULL,
	[RootShadowingRootColorLengthID] [int] NULL,
	[RootShadowingRootColorID] [int] NULL,
	[UpdatedDueDate] [datetime] NULL,
 CONSTRAINT [PK_datHairSystemOrder_1] PRIMARY KEY NONCLUSTERED
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_datHairSystemOrder] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [CV_datHairSystemOrder_ClientMembershipGUID] ON [dbo].[datHairSystemOrder]
(
	[ClientMembershipGUID] ASC
)
INCLUDE([HairSystemOrderDate],[HairSystemOrderGUID],[HairSystemID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_CenterIDHairSystemOrderStatusIDAppliedDate] ON [dbo].[datHairSystemOrder]
(
	[CenterID] ASC,
	[HairSystemOrderStatusID] ASC,
	[AppliedDate] ASC
)
INCLUDE([ClientGUID],[ClientMembershipGUID],[HairSystemDesignTemplateID],[HairSystemID],[HairSystemOrderGUID],[HairSystemOrderNumber],[IsStockInventoryFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_ClientGUIDHairSystemOrderDate] ON [dbo].[datHairSystemOrder]
(
	[ClientGUID] ASC,
	[HairSystemOrderDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_ClientHomeCenterID_IsRepairOrderFlag_RequestForCreditDates] ON [dbo].[datHairSystemOrder]
(
	[ClientHomeCenterID] ASC,
	[IsRepairOrderFlag] DESC,
	[RequestForCreditAcceptedDate] DESC,
	[RequestForCreditDeclinedDate] DESC
)
INCLUDE([ClientMembershipGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_HairSystemOrderStatusID_AppliedDate] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderStatusID] ASC,
	[AppliedDate] DESC
)
INCLUDE([HairSystemOrderGUID],[ClientHomeCenterID],[ClientGUID],[ClientMembershipGUID],[HairSystemOrderDate],[HairSystemOrderNumber],[HairSystemID],[HairSystemDesignTemplateID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_OrderCenterStatus] ON [dbo].[datHairSystemOrder]
(
	[CenterID] ASC,
	[HairSystemOrderStatusID] ASC
)
INCLUDE([HairSystemOrderGUID],[ClientHomeCenterID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_OriginalHairSystemOrderGUID] ON [dbo].[datHairSystemOrder]
(
	[OriginalHairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrder_Misc] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderStatusID] ASC,
	[ClientHomeCenterID] ASC,
	[HairSystemOrderGUID] ASC,
	[IsOnHoldForReviewFlag] ASC,
	[ClientMembershipGUID] ASC,
	[CenterID] ASC,
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderNumber],[RequestForCreditAcceptedDate],[RequestForCreditDeclinedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrder_Misc3] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderGUID] ASC,
	[HairSystemOrderStatusID] ASC,
	[ClientMembershipGUID] ASC,
	[ClientHomeCenterID] ASC,
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderNumber],[RequestForCreditAcceptedDate],[RequestForCreditDeclinedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [NC_datHairSystemOrder_IsRepairOrderFlag] ON [dbo].[datHairSystemOrder]
(
	[IsRepairOrderFlag] ASC
)
INCLUDE([HairSystemOrderStatusID],[TemplateAreaActualCalc],[HairSystemID],[HairSystemDensityID],[HairSystemHairLengthID],[HairSystemCurlID],[TemplateWidth],[TemplateWidthAdjustment],[TemplateHeight],[TemplateHeightAdjustment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrder_ChargeDecisionIDINCLHSOGUID] ON [dbo].[datHairSystemOrder]
(
	[ChargeDecisionID] ASC
)
INCLUDE([HairSystemOrderGUID],[CenterID],[ClientHomeCenterID],[HairSystemOrderStatusID],[ClientGUID],[ClientMembershipGUID],[HairSystemOrderNumber],[HairSystemID],[HairSystemDesignTemplateID],[HairSystemHairLengthID],[RequestForCreditAcceptedDate],[RequestForCreditDeclinedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrder_HairSystemDesignTemplateID_INCLHCCHHH] ON [dbo].[datHairSystemOrder]
(
	[HairSystemDesignTemplateID] ASC
)
INCLUDE([HairSystemOrderGUID],[ClientHomeCenterID],[ClientGUID],[HairSystemOrderNumber],[HairSystemID],[HairSystemHairLengthID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrder_HSODateINCLHSOGUID] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderGUID],[HairSystemID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrderDate_HSODateINCLHairSystemGUID] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderGUID],[HairSystemID],[HairSystemDensityID],[HairSystemFrontalDensityID],[HairSystemHairLengthID],[HairSystemStyleID],[HairSystemCurlID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datHairSystemOrder_HairSystemOrderNumber] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datHairSystemOrder_HairSystemOrderStatusID_ClientHomeCenterID_CenterID_HairSystemOrderGUID] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderStatusID] ASC,
	[ClientHomeCenterID] ASC,
	[CenterID] ASC,
	[HairSystemOrderGUID] ASC
)
INCLUDE([ClientGUID],[ClientMembershipGUID],[HairSystemOrderDate],[HairSystemOrderNumber],[MeasurementEmployeeGUID],[HairSystemID],[CreateDate],[OrderedByEmployeeGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
