/* CreateDate: 05/05/2020 18:40:59.173 , ModifyDate: 05/05/2020 18:40:59.173 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_cfgSalesCode]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesCodeID], NULL as [SalesCodeSortOrder], NULL as [SalesCodeDescription], NULL as [SalesCodeDescriptionShort], NULL as [SalesCodeTypeID], NULL as [SalesCodeDepartmentID], NULL as [VendorID], NULL as [Barcode], NULL as [PriceDefault], NULL as [GLNumber], NULL as [ServiceDuration], NULL as [CanScheduleFlag], NULL as [FactoryOrderFlag], NULL as [IsRefundableFlag], NULL as [InventoryFlag], NULL as [SurgeryCloseoutFlag], NULL as [TechnicalProfileFlag], NULL as [AdjustContractPaidAmountFlag], NULL as [IsPriceAdjustableFlag], NULL as [IsDiscountableFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsARTenderRequiredFlag], NULL as [CanOrderFlag], NULL as [IsQuantityAdjustableFlag], NULL as [IsPhotoEnabledFlag], NULL as [IsEXTOnlyProductFlag], NULL as [HairSystemID], NULL as [SaleCount], NULL as [IsSalesCodeKitFlag], NULL as [BIOGeneralLedgerID], NULL as [EXTGeneralLedgerID], NULL as [SURGeneralLedgerID], NULL as [BrandID], NULL as [Product], NULL as [Size], NULL as [IsRefundablePayment], NULL as [IsNSFChargebackFee], NULL as [InterCompanyPrice], NULL as [IsQuantityRequired], NULL as [XTRGeneralLedgerID], NULL as [DescriptionResourceKey], NULL as [IsBosleySalesCode], NULL as [IsVisibleToConsultant], NULL as [IsSerialized], NULL as [SerialNumberRegEx], NULL as [QuantityPerPack], NULL as [PackUnitOfMeasureID], NULL as [InventorySalesCodeID], NULL as [IsVisibleToClient], NULL as [CanBeManagedByClient], NULL as [IsManagedByClientOnly], NULL as [ClientDescription], NULL as [MDPGeneralLedgerID], NULL as [PackSKU]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesCodeID], t.[SalesCodeSortOrder], t.[SalesCodeDescription], t.[SalesCodeDescriptionShort], t.[SalesCodeTypeID], t.[SalesCodeDepartmentID], t.[VendorID], t.[Barcode], t.[PriceDefault], t.[GLNumber], t.[ServiceDuration], t.[CanScheduleFlag], t.[FactoryOrderFlag], t.[IsRefundableFlag], t.[InventoryFlag], t.[SurgeryCloseoutFlag], t.[TechnicalProfileFlag], t.[AdjustContractPaidAmountFlag], t.[IsPriceAdjustableFlag], t.[IsDiscountableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsARTenderRequiredFlag], t.[CanOrderFlag], t.[IsQuantityAdjustableFlag], t.[IsPhotoEnabledFlag], t.[IsEXTOnlyProductFlag], t.[HairSystemID], t.[SaleCount], t.[IsSalesCodeKitFlag], t.[BIOGeneralLedgerID], t.[EXTGeneralLedgerID], t.[SURGeneralLedgerID], t.[BrandID], t.[Product], t.[Size], t.[IsRefundablePayment], t.[IsNSFChargebackFee], t.[InterCompanyPrice], t.[IsQuantityRequired], t.[XTRGeneralLedgerID], t.[DescriptionResourceKey], t.[IsBosleySalesCode], t.[IsVisibleToConsultant], t.[IsSerialized], t.[SerialNumberRegEx], t.[QuantityPerPack], t.[PackUnitOfMeasureID], t.[InventorySalesCodeID], t.[IsVisibleToClient], t.[CanBeManagedByClient], t.[IsManagedByClientOnly], t.[ClientDescription], t.[MDPGeneralLedgerID], t.[PackSKU]
	from [cdc].[dbo_cfgSalesCode_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesCodeID], t.[SalesCodeSortOrder], t.[SalesCodeDescription], t.[SalesCodeDescriptionShort], t.[SalesCodeTypeID], t.[SalesCodeDepartmentID], t.[VendorID], t.[Barcode], t.[PriceDefault], t.[GLNumber], t.[ServiceDuration], t.[CanScheduleFlag], t.[FactoryOrderFlag], t.[IsRefundableFlag], t.[InventoryFlag], t.[SurgeryCloseoutFlag], t.[TechnicalProfileFlag], t.[AdjustContractPaidAmountFlag], t.[IsPriceAdjustableFlag], t.[IsDiscountableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsARTenderRequiredFlag], t.[CanOrderFlag], t.[IsQuantityAdjustableFlag], t.[IsPhotoEnabledFlag], t.[IsEXTOnlyProductFlag], t.[HairSystemID], t.[SaleCount], t.[IsSalesCodeKitFlag], t.[BIOGeneralLedgerID], t.[EXTGeneralLedgerID], t.[SURGeneralLedgerID], t.[BrandID], t.[Product], t.[Size], t.[IsRefundablePayment], t.[IsNSFChargebackFee], t.[InterCompanyPrice], t.[IsQuantityRequired], t.[XTRGeneralLedgerID], t.[DescriptionResourceKey], t.[IsBosleySalesCode], t.[IsVisibleToConsultant], t.[IsSerialized], t.[SerialNumberRegEx], t.[QuantityPerPack], t.[PackUnitOfMeasureID], t.[InventorySalesCodeID], t.[IsVisibleToClient], t.[CanBeManagedByClient], t.[IsManagedByClientOnly], t.[ClientDescription], t.[MDPGeneralLedgerID], t.[PackSKU]
	from [cdc].[dbo_cfgSalesCode_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
