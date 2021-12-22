/* CreateDate: 10/04/2010 12:08:45.773 , ModifyDate: 12/07/2021 16:20:16.190 */
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
	[UpdateStamp] [timestamp] NULL,
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
 CONSTRAINT [PK_datHairSystemOrder] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datHairSystemOrder_HairSystemOrderNumber] UNIQUE NONCLUSTERED
(
	[HairSystemOrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CV_datHairSystemOrder_ClientMembershipGUID] ON [dbo].[datHairSystemOrder]
(
	[ClientMembershipGUID] ASC
)
INCLUDE([HairSystemOrderDate],[HairSystemOrderGUID],[HairSystemID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_CenterIDHairSystemOrderStatusIDAppliedDate] ON [dbo].[datHairSystemOrder]
(
	[CenterID] ASC,
	[HairSystemOrderStatusID] ASC,
	[AppliedDate] ASC
)
INCLUDE([ClientGUID],[ClientMembershipGUID],[HairSystemDesignTemplateID],[HairSystemID],[HairSystemOrderGUID],[HairSystemOrderNumber],[IsStockInventoryFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_ClientGUIDHairSystemOrderDate] ON [dbo].[datHairSystemOrder]
(
	[ClientGUID] ASC,
	[HairSystemOrderDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_ClientHomeCenterID_IsRepairOrderFlag_RequestForCreditDates] ON [dbo].[datHairSystemOrder]
(
	[ClientHomeCenterID] ASC,
	[IsRepairOrderFlag] DESC,
	[RequestForCreditAcceptedDate] DESC,
	[RequestForCreditDeclinedDate] DESC
)
INCLUDE([ClientMembershipGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_HairSystemOrderStatusID_AppliedDate] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderStatusID] ASC,
	[AppliedDate] DESC
)
INCLUDE([HairSystemOrderGUID],[ClientHomeCenterID],[ClientGUID],[ClientMembershipGUID],[HairSystemOrderDate],[HairSystemOrderNumber],[HairSystemID],[HairSystemDesignTemplateID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_OrderCenterStatus] ON [dbo].[datHairSystemOrder]
(
	[CenterID] ASC,
	[HairSystemOrderStatusID] ASC
)
INCLUDE([HairSystemOrderGUID],[ClientHomeCenterID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datHairSystemOrder_OriginalHairSystemOrderGUID] ON [dbo].[datHairSystemOrder]
(
	[OriginalHairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
INCLUDE([HairSystemOrderNumber],[RequestForCreditAcceptedDate],[RequestForCreditDeclinedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrder_Misc3] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderGUID] ASC,
	[HairSystemOrderStatusID] ASC,
	[ClientMembershipGUID] ASC,
	[ClientHomeCenterID] ASC,
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderNumber],[RequestForCreditAcceptedDate],[RequestForCreditDeclinedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [NC_datHairSystemOrder_IsRepairOrderFlag] ON [dbo].[datHairSystemOrder]
(
	[IsRepairOrderFlag] ASC
)
INCLUDE([HairSystemOrderStatusID],[TemplateAreaActualCalc],[HairSystemID],[HairSystemDensityID],[HairSystemHairLengthID],[HairSystemCurlID],[TemplateWidth],[TemplateWidthAdjustment],[TemplateHeight],[TemplateHeightAdjustment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrder_ChargeDecisionIDINCLHSOGUID] ON [dbo].[datHairSystemOrder]
(
	[ChargeDecisionID] ASC
)
INCLUDE([HairSystemOrderGUID],[CenterID],[ClientHomeCenterID],[HairSystemOrderStatusID],[ClientGUID],[ClientMembershipGUID],[HairSystemOrderNumber],[HairSystemID],[HairSystemDesignTemplateID],[HairSystemHairLengthID],[RequestForCreditAcceptedDate],[RequestForCreditDeclinedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrder_HairSystemDesignTemplateID_INCLHCCHHH] ON [dbo].[datHairSystemOrder]
(
	[HairSystemDesignTemplateID] ASC
)
INCLUDE([HairSystemOrderGUID],[ClientHomeCenterID],[ClientGUID],[HairSystemOrderNumber],[HairSystemID],[HairSystemHairLengthID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrder_HSODateINCLHSOGUID] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderGUID],[HairSystemID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datHairSystemOrderDate_HSODateINCLHairSystemGUID] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderDate] ASC
)
INCLUDE([HairSystemOrderGUID],[HairSystemID],[HairSystemDensityID],[HairSystemFrontalDensityID],[HairSystemHairLengthID],[HairSystemStyleID],[HairSystemCurlID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datHairSystemOrder_HairSystemOrderStatusID_ClientHomeCenterID_CenterID_HairSystemOrderGUID] ON [dbo].[datHairSystemOrder]
(
	[HairSystemOrderStatusID] ASC,
	[ClientHomeCenterID] ASC,
	[CenterID] ASC,
	[HairSystemOrderGUID] ASC
)
INCLUDE([ClientGUID],[ClientMembershipGUID],[HairSystemOrderDate],[HairSystemOrderNumber],[MeasurementEmployeeGUID],[HairSystemID],[CreateDate],[OrderedByEmployeeGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [CostContract]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [CostActual]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [CenterPrice]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [CenterUseIsPermFlag]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [IsOnHoldForReviewFlag]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [IsSampleOrderFlag]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  CONSTRAINT [DF_datHairSystemOrder_CostFactoryShipped]  DEFAULT ((0)) FOR [CostFactoryShipped]
GO
ALTER TABLE [dbo].[datHairSystemOrder] ADD  DEFAULT ((0)) FOR [IsFashionHairlineHighlightsFlag]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [datHairSystemOrder_cfgHairSystemCenterContractPricing] FOREIGN KEY([HairSystemCenterContractPricingID])
REFERENCES [dbo].[cfgHairSystemCenterContractPricing] ([HairSystemCenterContractPricingID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [datHairSystemOrder_cfgHairSystemCenterContractPricing]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [datHairSystemOrder_cfgVendor] FOREIGN KEY([ManualVendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [datHairSystemOrder_cfgVendor]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [datHairSystemOrder_datEmployee_OrderedByEmployee] FOREIGN KEY([OrderedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [datHairSystemOrder_datEmployee_OrderedByEmployee]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_cfgCenter]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_cfgCenter1] FOREIGN KEY([ClientHomeCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_cfgCenter1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_cfgHairSystem]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_cfgHairSystemLocation] FOREIGN KEY([HairSystemLocationID])
REFERENCES [dbo].[cfgHairSystemLocation] ([HairSystemLocationID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_cfgHairSystemLocation]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_cfgHairSystemVendorContractPricing] FOREIGN KEY([HairSystemVendorContractPricingID])
REFERENCES [dbo].[cfgHairSystemVendorContractPricing] ([HairSystemVendorContractPricingID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_cfgHairSystemVendorContractPricing]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_cfgHairSystemVendorContractPricing2] FOREIGN KEY([FactoryShippedHairSystemVendorContractPricingID])
REFERENCES [dbo].[cfgHairSystemVendorContractPricing] ([HairSystemVendorContractPricingID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_cfgHairSystemVendorContractPricing2]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datClient]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datClient1] FOREIGN KEY([OriginalClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datClient1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datClientMembership]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datClientMembership1] FOREIGN KEY([OriginalClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datClientMembership1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datEmployee] FOREIGN KEY([MeasurementEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datEmployee]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_datHairSystemOrder] FOREIGN KEY([OriginalHairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpChargeDecision] FOREIGN KEY([ChargeDecisionID])
REFERENCES [dbo].[lkpChargeDecision] ([ChargeDecisionID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpChargeDecision]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage] FOREIGN KEY([Highlight1FrontHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage1] FOREIGN KEY([Highlight1TempleHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage10] FOREIGN KEY([Highlight2CrownHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage10]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage11] FOREIGN KEY([Highlight2BackHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage11]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage12] FOREIGN KEY([GreyFrontHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage12]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage13] FOREIGN KEY([GreyTempleHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage13]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage14] FOREIGN KEY([GreyTopHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage14]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage15] FOREIGN KEY([GreySidesHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage15]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage16] FOREIGN KEY([GreyCrownHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage16]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage17] FOREIGN KEY([GreyBackHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage17]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage2] FOREIGN KEY([Highlight1TopHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage2]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage3] FOREIGN KEY([Highlight1SidesHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage3]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage4] FOREIGN KEY([Highlight1CrownHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage4]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage5] FOREIGN KEY([Highlight1BackHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage5]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage6] FOREIGN KEY([Highlight2FrontHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage6]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage7] FOREIGN KEY([Highlight2TempleHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage7]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage8] FOREIGN KEY([Highlight2TopHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage8]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage9] FOREIGN KEY([Highlight2SidesHairSystemColorPercentageID])
REFERENCES [dbo].[lkpHairSystemColorPercentage] ([HairSystemColorPercentageID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemColorPercentage9]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemCurl] FOREIGN KEY([HairSystemCurlID])
REFERENCES [dbo].[lkpHairSystemCurl] ([HairSystemCurlID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemCurl]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemDensity] FOREIGN KEY([HairSystemDensityID])
REFERENCES [dbo].[lkpHairSystemDensity] ([HairSystemDensityID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemDensity]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemDesignTemplate] FOREIGN KEY([HairSystemDesignTemplateID])
REFERENCES [dbo].[lkpHairSystemDesignTemplate] ([HairSystemDesignTemplateID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemDesignTemplate]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFactoryNote] FOREIGN KEY([HairSystemFactoryNoteID])
REFERENCES [dbo].[lkpHairSystemFactoryNote] ([HairSystemFactoryNoteID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFactoryNote]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFrontalDensity] FOREIGN KEY([HairSystemFrontalDensityID])
REFERENCES [dbo].[lkpHairSystemFrontalDensity] ([HairSystemFrontalDensityID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFrontalDensity]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFrontalDesign] FOREIGN KEY([HairSystemFrontalDesignID])
REFERENCES [dbo].[lkpHairSystemFrontalDesign] ([HairSystemFrontalDesignID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFrontalDesign]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFrontalLaceLength] FOREIGN KEY([HairSystemFrontalLaceLengthID])
REFERENCES [dbo].[lkpHairSystemFrontalLaceLength] ([HairSystemFrontalLaceLengthID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemFrontalLaceLength]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor] FOREIGN KEY([ColorFrontHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor_RootShadowColor] FOREIGN KEY([RootShadowingRootColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor_RootShadowColor]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor1] FOREIGN KEY([ColorTempleHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor10] FOREIGN KEY([Highlight1CrownHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor10]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor11] FOREIGN KEY([Highlight1BackHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor11]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor12] FOREIGN KEY([Highlight2FrontHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor12]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor13] FOREIGN KEY([Highlight2TempleHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor13]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor14] FOREIGN KEY([Highlight2TopHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor14]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor15] FOREIGN KEY([Highlight2SidesHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor15]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor16] FOREIGN KEY([Highlight2CrownHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor16]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor17] FOREIGN KEY([Highlight2BackHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor17]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor2] FOREIGN KEY([ColorTopHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor2]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor3] FOREIGN KEY([ColorSidesHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor3]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor4] FOREIGN KEY([ColorCrownHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor4]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor5] FOREIGN KEY([ColorBackHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor5]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor6] FOREIGN KEY([Highlight1FrontHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor6]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor7] FOREIGN KEY([Highlight1TempleHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor7]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor8] FOREIGN KEY([Highlight1TopHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor8]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor9] FOREIGN KEY([Highlight1SidesHairSystemHairColorID])
REFERENCES [dbo].[lkpHairSystemHairColor] ([HairSystemHairColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairColor9]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairLength] FOREIGN KEY([HairSystemHairLengthID])
REFERENCES [dbo].[lkpHairSystemHairLength] ([HairSystemHairLengthID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairLength]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial] FOREIGN KEY([ColorHairSystemHairMaterialID])
REFERENCES [dbo].[lkpHairSystemHairMaterial] ([HairSystemHairMaterialID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial1] FOREIGN KEY([Highlight1HairSystemHairMaterialID])
REFERENCES [dbo].[lkpHairSystemHairMaterial] ([HairSystemHairMaterialID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial2] FOREIGN KEY([Highlight2HairSystemHairMaterialID])
REFERENCES [dbo].[lkpHairSystemHairMaterial] ([HairSystemHairMaterialID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial2]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial3] FOREIGN KEY([GreyHairSystemHairMaterialID])
REFERENCES [dbo].[lkpHairSystemHairMaterial] ([HairSystemHairMaterialID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHairMaterial3]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHighlight] FOREIGN KEY([Highlight1HairSystemHighlightID])
REFERENCES [dbo].[lkpHairSystemHighlight] ([HairSystemHighlightID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHighlight]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHighlight1] FOREIGN KEY([Highlight2HairSystemHighlightID])
REFERENCES [dbo].[lkpHairSystemHighlight] ([HairSystemHighlightID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHighlight1]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHoldReason] FOREIGN KEY([HairSystemHoldReasonID])
REFERENCES [dbo].[lkpHairSystemHoldReason] ([HairSystemHoldReasonID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemHoldReason]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemMatrixColor] FOREIGN KEY([HairSystemMatrixColorID])
REFERENCES [dbo].[lkpHairSystemMatrixColor] ([HairSystemMatrixColorID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemMatrixColor]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemOrderSpecialInstruction] FOREIGN KEY([HairSystemOrderSpecialInstructionID])
REFERENCES [dbo].[lkpHairSystemOrderSpecialInstruction] ([HairSystemOrderSpecialInstructionID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemOrderSpecialInstruction]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemOrderStatus] FOREIGN KEY([HairSystemOrderStatusID])
REFERENCES [dbo].[lkpHairSystemOrderStatus] ([HairSystemOrderStatusID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemOrderStatus]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemRecession] FOREIGN KEY([HairSystemRecessionID])
REFERENCES [dbo].[lkpHairSystemRecession] ([HairSystemRecessionID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemRecession]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemRedoReason] FOREIGN KEY([HairSystemRedoReasonID])
REFERENCES [dbo].[lkpHairSystemRedoReason] ([HairSystemRedoReasonID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemRedoReason]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemRepairReason] FOREIGN KEY([HairSystemRepairReasonID])
REFERENCES [dbo].[lkpHairSystemRepairReason] ([HairSystemRepairReasonID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemRepairReason]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemStyle] FOREIGN KEY([HairSystemStyleID])
REFERENCES [dbo].[lkpHairSystemStyle] ([HairSystemStyleID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpHairSystemStyle]
GO
ALTER TABLE [dbo].[datHairSystemOrder]  WITH CHECK ADD  CONSTRAINT [FK_datHairSystemOrder_lkpRootShadowingRootColorLength] FOREIGN KEY([RootShadowingRootColorLengthID])
REFERENCES [dbo].[lkpRootShadowingRootColorLength] ([RootShadowingRootColorLengthID])
GO
ALTER TABLE [dbo].[datHairSystemOrder] CHECK CONSTRAINT [FK_datHairSystemOrder_lkpRootShadowingRootColorLength]
GO
