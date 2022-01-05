/* CreateDate: 01/03/2022 11:03:54.480 , ModifyDate: 01/03/2022 11:03:54.480 */
GO
CREATE TABLE [dbo].[datHairSystemOrder_bak](
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
	[TemplateWidthActualCalc] [decimal](11, 4) NULL,
	[TemplateHeight] [decimal](10, 4) NULL,
	[TemplateHeightAdjustment] [decimal](10, 4) NULL,
	[TemplateHeightActualCalc] [decimal](11, 4) NULL,
	[TemplateAreaActualCalc] [decimal](23, 8) NULL,
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
	[UpdatedDueDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
