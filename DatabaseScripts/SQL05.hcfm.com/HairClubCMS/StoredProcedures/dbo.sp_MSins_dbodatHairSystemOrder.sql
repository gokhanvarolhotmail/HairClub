/* CreateDate: 10/19/2020 08:36:30.567 , ModifyDate: 10/19/2020 08:36:30.567 */
GO
create procedure [dbo].[sp_MSins_dbodatHairSystemOrder]     @c1 uniqueidentifier,     @c2 int,     @c3 int,     @c4 int,     @c5 uniqueidentifier,     @c6 uniqueidentifier,     @c7 uniqueidentifier,     @c8 uniqueidentifier,     @c9 datetime,     @c10 nvarchar(50),     @c11 uniqueidentifier,     @c12 datetime,     @c13 datetime,     @c14 datetime,     @c15 bit,     @c16 bit,     @c17 bit,     @c18 bit,     @c19 bit,     @c20 uniqueidentifier,     @c21 decimal(10,4),     @c22 decimal(10,4),     @c23 decimal(10,4),     @c24 decimal(10,4),     @c25 int,     @c26 int,     @c27 int,     @c28 int,     @c29 int,     @c30 int,     @c31 int,     @c32 int,     @c33 int,     @c34 int,     @c35 int,     @c36 int,     @c37 int,     @c38 int,     @c39 int,     @c40 int,     @c41 int,     @c42 int,     @c43 int,     @c44 int,     @c45 int,     @c46 int,     @c47 int,     @c48 int,     @c49 int,     @c50 int,     @c51 int,     @c52 int,     @c53 int,     @c54 int,     @c55 int,     @c56 int,     @c57 int,     @c58 int,     @c59 int,     @c60 int,     @c61 int,     @c62 int,     @c63 int,     @c64 int,     @c65 int,     @c66 int,     @c67 int,     @c68 int,     @c69 int,     @c70 int,     @c71 int,     @c72 int,     @c73 int,     @c74 int,     @c75 int,     @c76 int,     @c77 int,     @c78 money,     @c79 money,     @c80 money,     @c81 int,     @c82 decimal(10,4),     @c83 bit,     @c84 int,     @c85 int,     @c86 ntext,     @c87 datetime,     @c88 nvarchar(25),     @c89 datetime,     @c90 nvarchar(25),     @c91 binary(8),     @c92 int,     @c93 int,     @c94 uniqueidentifier,     @c95 int,     @c96 int,     @c97 int,     @c98 int,     @c99 bit,     @c100 bit,     @c101 datetime,     @c102 datetime,     @c103 datetime,     @c104 int,     @c105 datetime,     @c106 datetime,     @c107 nvarchar(25),     @c108 nvarchar(25),     @c109 money,     @c110 int,     @c111 bit,     @c112 nvarchar(50),     @c113 bit,     @c114 bit,     @c115 bit,     @c116 bit,     @c117 bit,     @c118 bit,     @c119 int,     @c120 int,     @c121 datetime as begin   	insert into [dbo].[datHairSystemOrder] ( 		[HairSystemOrderGUID], 		[CenterID], 		[ClientHomeCenterID], 		[HairSystemOrderStatusID], 		[ClientGUID], 		[ClientMembershipGUID], 		[OriginalClientGUID], 		[OriginalClientMembershipGUID], 		[HairSystemOrderDate], 		[HairSystemOrderNumber], 		[MeasurementEmployeeGUID], 		[DueDate], 		[TemplateReceivedDate], 		[AppliedDate], 		[IsRepairOrderFlag], 		[IsRedoOrderFlag], 		[IsRushOrderFlag], 		[IsStockInventoryFlag], 		[IsOnCenterHoldFlag], 		[OriginalHairSystemOrderGUID], 		[TemplateWidth], 		[TemplateWidthAdjustment], 		[TemplateHeight], 		[TemplateHeightAdjustment], 		[HairSystemOrderSpecialInstructionID], 		[HairSystemID], 		[HairSystemMatrixColorID], 		[HairSystemDesignTemplateID], 		[HairSystemRecessionID], 		[HairSystemDensityID], 		[HairSystemFrontalDensityID], 		[HairSystemHairLengthID], 		[HairSystemFrontalDesignID], 		[HairSystemCurlID], 		[HairSystemStyleID], 		[ColorHairSystemHairMaterialID], 		[ColorFrontHairSystemHairColorID], 		[ColorTempleHairSystemHairColorID], 		[ColorTopHairSystemHairColorID], 		[ColorSidesHairSystemHairColorID], 		[ColorCrownHairSystemHairColorID], 		[ColorBackHairSystemHairColorID], 		[Highlight1HairSystemHairMaterialID], 		[Highlight1HairSystemHighlightID], 		[Highlight1FrontHairSystemHairColorID], 		[Highlight1TempleHairSystemHairColorID], 		[Highlight1TopHairSystemHairColorID], 		[Highlight1SidesHairSystemHairColorID], 		[Highlight1CrownHairSystemHairColorID], 		[Highlight1BackHairSystemHairColorID], 		[Highlight1FrontHairSystemColorPercentageID], 		[Highlight1TempleHairSystemColorPercentageID], 		[Highlight1TopHairSystemColorPercentageID], 		[Highlight1SidesHairSystemColorPercentageID], 		[Highlight1CrownHairSystemColorPercentageID], 		[Highlight1BackHairSystemColorPercentageID], 		[Highlight2HairSystemHairMaterialID], 		[Highlight2HairSystemHighlightID], 		[Highlight2FrontHairSystemHairColorID], 		[Highlight2TempleHairSystemHairColorID], 		[Highlight2TopHairSystemHairColorID], 		[Highlight2SidesHairSystemHairColorID], 		[Highlight2CrownHairSystemHairColorID], 		[Highlight2BackHairSystemHairColorID], 		[Highlight2FrontHairSystemColorPercentageID], 		[Highlight2TempleHairSystemColorPercentageID], 		[Highlight2TopHairSystemColorPercentageID], 		[Highlight2SidesHairSystemColorPercentageID], 		[Highlight2CrownHairSystemColorPercentageID], 		[Highlight2BackHairSystemColorPercentageID], 		[GreyHairSystemHairMaterialID], 		[GreyFrontHairSystemColorPercentageID], 		[GreyTempleHairSystemColorPercentageID], 		[GreyTopHairSystemColorPercentageID], 		[GreySidesHairSystemColorPercentageID], 		[GreyCrownHairSystemColorPercentageID], 		[GreyBackHairSystemColorPercentageID], 		[CostContract], 		[CostActual], 		[CenterPrice], 		[HairSystemVendorContractPricingID], 		[CenterUseFromBridgeDistance], 		[CenterUseIsPermFlag], 		[HairSystemRepairReasonID], 		[HairSystemRedoReasonID], 		[FactoryNote], 		[CreateDate], 		[CreateUser], 		[LastUpdate], 		[LastUpdateUser], 		[UpdateStamp], 		[HairSystemCenterContractPricingID], 		[ManualVendorID], 		[OrderedByEmployeeGUID], 		[HairSystemHoldReasonID], 		[HairSystemFactoryNoteID], 		[HairSystemFrontalLaceLengthID], 		[HairSystemLocationID], 		[IsOnHoldForReviewFlag], 		[IsSampleOrderFlag], 		[RequestForCreditAcceptedDate], 		[RequestForCreditDeclinedDate], 		[AllocationDate], 		[ChargeDecisionID], 		[ReceivedCorpDate], 		[ShippedFromCorpDate], 		[SubFactoryCode], 		[PodCode], 		[CostFactoryShipped], 		[FactoryShippedHairSystemVendorContractPricingID], 		[IsFashionHairlineHighlightsFlag], 		[VendorHairSystemOrderNumber], 		[IsSignatureHairlineAddOn], 		[IsOmbreAddOn], 		[IsExtendedLaceAddOn], 		[IsLongHairAddOn], 		[IsCuticleIntactHairAddOn], 		[IsRootShadowingAddOn], 		[RootShadowingRootColorLengthID], 		[RootShadowingRootColorID], 		[UpdatedDueDate] 	) values ( 		@c1, 		@c2, 		@c3, 		@c4, 		@c5, 		@c6, 		@c7, 		@c8, 		@c9, 		@c10, 		@c11, 		@c12, 		@c13, 		@c14, 		@c15, 		@c16, 		@c17, 		@c18, 		@c19, 		@c20, 		@c21, 		@c22, 		@c23, 		@c24, 		@c25, 		@c26, 		@c27, 		@c28, 		@c29, 		@c30, 		@c31, 		@c32, 		@c33, 		@c34, 		@c35, 		@c36, 		@c37, 		@c38, 		@c39, 		@c40, 		@c41, 		@c42, 		@c43, 		@c44, 		@c45, 		@c46, 		@c47, 		@c48, 		@c49, 		@c50, 		@c51, 		@c52, 		@c53, 		@c54, 		@c55, 		@c56, 		@c57, 		@c58, 		@c59, 		@c60, 		@c61, 		@c62, 		@c63, 		@c64, 		@c65, 		@c66, 		@c67, 		@c68, 		@c69, 		@c70, 		@c71, 		@c72, 		@c73, 		@c74, 		@c75, 		@c76, 		@c77, 		@c78, 		@c79, 		@c80, 		@c81, 		@c82, 		@c83, 		@c84, 		@c85, 		@c86, 		@c87, 		@c88, 		@c89, 		@c90, 		@c91, 		@c92, 		@c93, 		@c94, 		@c95, 		@c96, 		@c97, 		@c98, 		@c99, 		@c100, 		@c101, 		@c102, 		@c103, 		@c104, 		@c105, 		@c106, 		@c107, 		@c108, 		@c109, 		@c110, 		@c111, 		@c112, 		@c113, 		@c114, 		@c115, 		@c116, 		@c117, 		@c118, 		@c119, 		@c120, 		@c121	)  end    --
GO