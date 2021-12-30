/* CreateDate: 05/05/2020 18:41:07.607 , ModifyDate: 05/05/2020 18:41:07.607 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datHairSystemOrder]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [HairSystemOrderGUID], NULL as [CenterID], NULL as [ClientHomeCenterID], NULL as [HairSystemOrderStatusID], NULL as [ClientGUID], NULL as [ClientMembershipGUID], NULL as [OriginalClientGUID], NULL as [OriginalClientMembershipGUID], NULL as [HairSystemOrderDate], NULL as [HairSystemOrderNumber], NULL as [MeasurementEmployeeGUID], NULL as [DueDate], NULL as [TemplateReceivedDate], NULL as [AppliedDate], NULL as [IsRepairOrderFlag], NULL as [IsRedoOrderFlag], NULL as [IsRushOrderFlag], NULL as [IsStockInventoryFlag], NULL as [IsOnCenterHoldFlag], NULL as [OriginalHairSystemOrderGUID], NULL as [TemplateWidth], NULL as [TemplateWidthAdjustment], NULL as [TemplateWidthActualCalc], NULL as [TemplateHeight], NULL as [TemplateHeightAdjustment], NULL as [TemplateHeightActualCalc], NULL as [TemplateAreaActualCalc], NULL as [HairSystemOrderSpecialInstructionID], NULL as [HairSystemID], NULL as [HairSystemMatrixColorID], NULL as [HairSystemDesignTemplateID], NULL as [HairSystemRecessionID], NULL as [HairSystemDensityID], NULL as [HairSystemFrontalDensityID], NULL as [HairSystemHairLengthID], NULL as [HairSystemFrontalDesignID], NULL as [HairSystemCurlID], NULL as [HairSystemStyleID], NULL as [ColorHairSystemHairMaterialID], NULL as [ColorFrontHairSystemHairColorID], NULL as [ColorTempleHairSystemHairColorID], NULL as [ColorTopHairSystemHairColorID], NULL as [ColorSidesHairSystemHairColorID], NULL as [ColorCrownHairSystemHairColorID], NULL as [ColorBackHairSystemHairColorID], NULL as [Highlight1HairSystemHairMaterialID], NULL as [Highlight1HairSystemHighlightID], NULL as [Highlight1FrontHairSystemHairColorID], NULL as [Highlight1TempleHairSystemHairColorID], NULL as [Highlight1TopHairSystemHairColorID], NULL as [Highlight1SidesHairSystemHairColorID], NULL as [Highlight1CrownHairSystemHairColorID], NULL as [Highlight1BackHairSystemHairColorID], NULL as [Highlight1FrontHairSystemColorPercentageID], NULL as [Highlight1TempleHairSystemColorPercentageID], NULL as [Highlight1TopHairSystemColorPercentageID], NULL as [Highlight1SidesHairSystemColorPercentageID], NULL as [Highlight1CrownHairSystemColorPercentageID], NULL as [Highlight1BackHairSystemColorPercentageID], NULL as [Highlight2HairSystemHairMaterialID], NULL as [Highlight2HairSystemHighlightID], NULL as [Highlight2FrontHairSystemHairColorID], NULL as [Highlight2TempleHairSystemHairColorID], NULL as [Highlight2TopHairSystemHairColorID], NULL as [Highlight2SidesHairSystemHairColorID], NULL as [Highlight2CrownHairSystemHairColorID], NULL as [Highlight2BackHairSystemHairColorID], NULL as [Highlight2FrontHairSystemColorPercentageID], NULL as [Highlight2TempleHairSystemColorPercentageID], NULL as [Highlight2TopHairSystemColorPercentageID], NULL as [Highlight2SidesHairSystemColorPercentageID], NULL as [Highlight2CrownHairSystemColorPercentageID], NULL as [Highlight2BackHairSystemColorPercentageID], NULL as [GreyHairSystemHairMaterialID], NULL as [GreyFrontHairSystemColorPercentageID], NULL as [GreyTempleHairSystemColorPercentageID], NULL as [GreyTopHairSystemColorPercentageID], NULL as [GreySidesHairSystemColorPercentageID], NULL as [GreyCrownHairSystemColorPercentageID], NULL as [GreyBackHairSystemColorPercentageID], NULL as [CostContract], NULL as [CostActual], NULL as [CenterPrice], NULL as [HairSystemVendorContractPricingID], NULL as [CenterUseFromBridgeDistance], NULL as [CenterUseIsPermFlag], NULL as [HairSystemRepairReasonID], NULL as [HairSystemRedoReasonID], NULL as [FactoryNote], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [HairSystemCenterContractPricingID], NULL as [ManualVendorID], NULL as [OrderedByEmployeeGUID], NULL as [HairSystemHoldReasonID], NULL as [HairSystemFactoryNoteID], NULL as [HairSystemFrontalLaceLengthID], NULL as [HairSystemLocationID], NULL as [IsOnHoldForReviewFlag], NULL as [IsSampleOrderFlag], NULL as [RequestForCreditAcceptedDate], NULL as [RequestForCreditDeclinedDate], NULL as [AllocationDate], NULL as [ChargeDecisionID], NULL as [ReceivedCorpDate], NULL as [ShippedFromCorpDate], NULL as [SubFactoryCode], NULL as [PodCode], NULL as [CostFactoryShipped], NULL as [FactoryShippedHairSystemVendorContractPricingID], NULL as [IsFashionHairlineHighlightsFlag], NULL as [VendorHairSystemOrderNumber], NULL as [IsSignatureHairlineAddOn], NULL as [IsOmbreAddOn], NULL as [IsExtendedLaceAddOn], NULL as [IsLongHairAddOn], NULL as [IsCuticleIntactHairAddOn], NULL as [IsRootShadowingAddOn], NULL as [RootShadowingRootColorLengthID], NULL as [RootShadowingRootColorID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datHairSystemOrder', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemOrderGUID], t.[CenterID], t.[ClientHomeCenterID], t.[HairSystemOrderStatusID], t.[ClientGUID], t.[ClientMembershipGUID], t.[OriginalClientGUID], t.[OriginalClientMembershipGUID], t.[HairSystemOrderDate], t.[HairSystemOrderNumber], t.[MeasurementEmployeeGUID], t.[DueDate], t.[TemplateReceivedDate], t.[AppliedDate], t.[IsRepairOrderFlag], t.[IsRedoOrderFlag], t.[IsRushOrderFlag], t.[IsStockInventoryFlag], t.[IsOnCenterHoldFlag], t.[OriginalHairSystemOrderGUID], t.[TemplateWidth], t.[TemplateWidthAdjustment], t.[TemplateWidthActualCalc], t.[TemplateHeight], t.[TemplateHeightAdjustment], t.[TemplateHeightActualCalc], t.[TemplateAreaActualCalc], t.[HairSystemOrderSpecialInstructionID], t.[HairSystemID], t.[HairSystemMatrixColorID], t.[HairSystemDesignTemplateID], t.[HairSystemRecessionID], t.[HairSystemDensityID], t.[HairSystemFrontalDensityID], t.[HairSystemHairLengthID], t.[HairSystemFrontalDesignID], t.[HairSystemCurlID], t.[HairSystemStyleID], t.[ColorHairSystemHairMaterialID], t.[ColorFrontHairSystemHairColorID], t.[ColorTempleHairSystemHairColorID], t.[ColorTopHairSystemHairColorID], t.[ColorSidesHairSystemHairColorID], t.[ColorCrownHairSystemHairColorID], t.[ColorBackHairSystemHairColorID], t.[Highlight1HairSystemHairMaterialID], t.[Highlight1HairSystemHighlightID], t.[Highlight1FrontHairSystemHairColorID], t.[Highlight1TempleHairSystemHairColorID], t.[Highlight1TopHairSystemHairColorID], t.[Highlight1SidesHairSystemHairColorID], t.[Highlight1CrownHairSystemHairColorID], t.[Highlight1BackHairSystemHairColorID], t.[Highlight1FrontHairSystemColorPercentageID], t.[Highlight1TempleHairSystemColorPercentageID], t.[Highlight1TopHairSystemColorPercentageID], t.[Highlight1SidesHairSystemColorPercentageID], t.[Highlight1CrownHairSystemColorPercentageID], t.[Highlight1BackHairSystemColorPercentageID], t.[Highlight2HairSystemHairMaterialID], t.[Highlight2HairSystemHighlightID], t.[Highlight2FrontHairSystemHairColorID], t.[Highlight2TempleHairSystemHairColorID], t.[Highlight2TopHairSystemHairColorID], t.[Highlight2SidesHairSystemHairColorID], t.[Highlight2CrownHairSystemHairColorID], t.[Highlight2BackHairSystemHairColorID], t.[Highlight2FrontHairSystemColorPercentageID], t.[Highlight2TempleHairSystemColorPercentageID], t.[Highlight2TopHairSystemColorPercentageID], t.[Highlight2SidesHairSystemColorPercentageID], t.[Highlight2CrownHairSystemColorPercentageID], t.[Highlight2BackHairSystemColorPercentageID], t.[GreyHairSystemHairMaterialID], t.[GreyFrontHairSystemColorPercentageID], t.[GreyTempleHairSystemColorPercentageID], t.[GreyTopHairSystemColorPercentageID], t.[GreySidesHairSystemColorPercentageID], t.[GreyCrownHairSystemColorPercentageID], t.[GreyBackHairSystemColorPercentageID], t.[CostContract], t.[CostActual], t.[CenterPrice], t.[HairSystemVendorContractPricingID], t.[CenterUseFromBridgeDistance], t.[CenterUseIsPermFlag], t.[HairSystemRepairReasonID], t.[HairSystemRedoReasonID], t.[FactoryNote], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[HairSystemCenterContractPricingID], t.[ManualVendorID], t.[OrderedByEmployeeGUID], t.[HairSystemHoldReasonID], t.[HairSystemFactoryNoteID], t.[HairSystemFrontalLaceLengthID], t.[HairSystemLocationID], t.[IsOnHoldForReviewFlag], t.[IsSampleOrderFlag], t.[RequestForCreditAcceptedDate], t.[RequestForCreditDeclinedDate], t.[AllocationDate], t.[ChargeDecisionID], t.[ReceivedCorpDate], t.[ShippedFromCorpDate], t.[SubFactoryCode], t.[PodCode], t.[CostFactoryShipped], t.[FactoryShippedHairSystemVendorContractPricingID], t.[IsFashionHairlineHighlightsFlag], t.[VendorHairSystemOrderNumber], t.[IsSignatureHairlineAddOn], t.[IsOmbreAddOn], t.[IsExtendedLaceAddOn], t.[IsLongHairAddOn], t.[IsCuticleIntactHairAddOn], t.[IsRootShadowingAddOn], t.[RootShadowingRootColorLengthID], t.[RootShadowingRootColorID]
	from [cdc].[dbo_datHairSystemOrder_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datHairSystemOrder', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[HairSystemOrderGUID], t.[CenterID], t.[ClientHomeCenterID], t.[HairSystemOrderStatusID], t.[ClientGUID], t.[ClientMembershipGUID], t.[OriginalClientGUID], t.[OriginalClientMembershipGUID], t.[HairSystemOrderDate], t.[HairSystemOrderNumber], t.[MeasurementEmployeeGUID], t.[DueDate], t.[TemplateReceivedDate], t.[AppliedDate], t.[IsRepairOrderFlag], t.[IsRedoOrderFlag], t.[IsRushOrderFlag], t.[IsStockInventoryFlag], t.[IsOnCenterHoldFlag], t.[OriginalHairSystemOrderGUID], t.[TemplateWidth], t.[TemplateWidthAdjustment], t.[TemplateWidthActualCalc], t.[TemplateHeight], t.[TemplateHeightAdjustment], t.[TemplateHeightActualCalc], t.[TemplateAreaActualCalc], t.[HairSystemOrderSpecialInstructionID], t.[HairSystemID], t.[HairSystemMatrixColorID], t.[HairSystemDesignTemplateID], t.[HairSystemRecessionID], t.[HairSystemDensityID], t.[HairSystemFrontalDensityID], t.[HairSystemHairLengthID], t.[HairSystemFrontalDesignID], t.[HairSystemCurlID], t.[HairSystemStyleID], t.[ColorHairSystemHairMaterialID], t.[ColorFrontHairSystemHairColorID], t.[ColorTempleHairSystemHairColorID], t.[ColorTopHairSystemHairColorID], t.[ColorSidesHairSystemHairColorID], t.[ColorCrownHairSystemHairColorID], t.[ColorBackHairSystemHairColorID], t.[Highlight1HairSystemHairMaterialID], t.[Highlight1HairSystemHighlightID], t.[Highlight1FrontHairSystemHairColorID], t.[Highlight1TempleHairSystemHairColorID], t.[Highlight1TopHairSystemHairColorID], t.[Highlight1SidesHairSystemHairColorID], t.[Highlight1CrownHairSystemHairColorID], t.[Highlight1BackHairSystemHairColorID], t.[Highlight1FrontHairSystemColorPercentageID], t.[Highlight1TempleHairSystemColorPercentageID], t.[Highlight1TopHairSystemColorPercentageID], t.[Highlight1SidesHairSystemColorPercentageID], t.[Highlight1CrownHairSystemColorPercentageID], t.[Highlight1BackHairSystemColorPercentageID], t.[Highlight2HairSystemHairMaterialID], t.[Highlight2HairSystemHighlightID], t.[Highlight2FrontHairSystemHairColorID], t.[Highlight2TempleHairSystemHairColorID], t.[Highlight2TopHairSystemHairColorID], t.[Highlight2SidesHairSystemHairColorID], t.[Highlight2CrownHairSystemHairColorID], t.[Highlight2BackHairSystemHairColorID], t.[Highlight2FrontHairSystemColorPercentageID], t.[Highlight2TempleHairSystemColorPercentageID], t.[Highlight2TopHairSystemColorPercentageID], t.[Highlight2SidesHairSystemColorPercentageID], t.[Highlight2CrownHairSystemColorPercentageID], t.[Highlight2BackHairSystemColorPercentageID], t.[GreyHairSystemHairMaterialID], t.[GreyFrontHairSystemColorPercentageID], t.[GreyTempleHairSystemColorPercentageID], t.[GreyTopHairSystemColorPercentageID], t.[GreySidesHairSystemColorPercentageID], t.[GreyCrownHairSystemColorPercentageID], t.[GreyBackHairSystemColorPercentageID], t.[CostContract], t.[CostActual], t.[CenterPrice], t.[HairSystemVendorContractPricingID], t.[CenterUseFromBridgeDistance], t.[CenterUseIsPermFlag], t.[HairSystemRepairReasonID], t.[HairSystemRedoReasonID], t.[FactoryNote], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[HairSystemCenterContractPricingID], t.[ManualVendorID], t.[OrderedByEmployeeGUID], t.[HairSystemHoldReasonID], t.[HairSystemFactoryNoteID], t.[HairSystemFrontalLaceLengthID], t.[HairSystemLocationID], t.[IsOnHoldForReviewFlag], t.[IsSampleOrderFlag], t.[RequestForCreditAcceptedDate], t.[RequestForCreditDeclinedDate], t.[AllocationDate], t.[ChargeDecisionID], t.[ReceivedCorpDate], t.[ShippedFromCorpDate], t.[SubFactoryCode], t.[PodCode], t.[CostFactoryShipped], t.[FactoryShippedHairSystemVendorContractPricingID], t.[IsFashionHairlineHighlightsFlag], t.[VendorHairSystemOrderNumber], t.[IsSignatureHairlineAddOn], t.[IsOmbreAddOn], t.[IsExtendedLaceAddOn], t.[IsLongHairAddOn], t.[IsCuticleIntactHairAddOn], t.[IsRootShadowingAddOn], t.[RootShadowingRootColorLengthID], t.[RootShadowingRootColorID]
	from [cdc].[dbo_datHairSystemOrder_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datHairSystemOrder', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
