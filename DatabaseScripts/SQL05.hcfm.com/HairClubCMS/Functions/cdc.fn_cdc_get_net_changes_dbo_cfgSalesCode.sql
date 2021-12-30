/* CreateDate: 05/05/2020 18:40:59.183 , ModifyDate: 05/05/2020 18:40:59.183 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_cfgSalesCode]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesCodeID], NULL as [SalesCodeSortOrder], NULL as [SalesCodeDescription], NULL as [SalesCodeDescriptionShort], NULL as [SalesCodeTypeID], NULL as [SalesCodeDepartmentID], NULL as [VendorID], NULL as [Barcode], NULL as [PriceDefault], NULL as [GLNumber], NULL as [ServiceDuration], NULL as [CanScheduleFlag], NULL as [FactoryOrderFlag], NULL as [IsRefundableFlag], NULL as [InventoryFlag], NULL as [SurgeryCloseoutFlag], NULL as [TechnicalProfileFlag], NULL as [AdjustContractPaidAmountFlag], NULL as [IsPriceAdjustableFlag], NULL as [IsDiscountableFlag], NULL as [IsActiveFlag], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [IsARTenderRequiredFlag], NULL as [CanOrderFlag], NULL as [IsQuantityAdjustableFlag], NULL as [IsPhotoEnabledFlag], NULL as [IsEXTOnlyProductFlag], NULL as [HairSystemID], NULL as [SaleCount], NULL as [IsSalesCodeKitFlag], NULL as [BIOGeneralLedgerID], NULL as [EXTGeneralLedgerID], NULL as [SURGeneralLedgerID], NULL as [BrandID], NULL as [Product], NULL as [Size], NULL as [IsRefundablePayment], NULL as [IsNSFChargebackFee], NULL as [InterCompanyPrice], NULL as [IsQuantityRequired], NULL as [XTRGeneralLedgerID], NULL as [DescriptionResourceKey], NULL as [IsBosleySalesCode], NULL as [IsVisibleToConsultant], NULL as [IsSerialized], NULL as [SerialNumberRegEx], NULL as [QuantityPerPack], NULL as [PackUnitOfMeasureID], NULL as [InventorySalesCodeID], NULL as [IsVisibleToClient], NULL as [CanBeManagedByClient], NULL as [IsManagedByClientOnly], NULL as [ClientDescription], NULL as [MDPGeneralLedgerID], NULL as [PackSKU]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_440C3753
	    when 1 then __$operation
	    else
			case __$min_op_440C3753
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		null as __$update_mask , [SalesCodeID], [SalesCodeSortOrder], [SalesCodeDescription], [SalesCodeDescriptionShort], [SalesCodeTypeID], [SalesCodeDepartmentID], [VendorID], [Barcode], [PriceDefault], [GLNumber], [ServiceDuration], [CanScheduleFlag], [FactoryOrderFlag], [IsRefundableFlag], [InventoryFlag], [SurgeryCloseoutFlag], [TechnicalProfileFlag], [AdjustContractPaidAmountFlag], [IsPriceAdjustableFlag], [IsDiscountableFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsARTenderRequiredFlag], [CanOrderFlag], [IsQuantityAdjustableFlag], [IsPhotoEnabledFlag], [IsEXTOnlyProductFlag], [HairSystemID], [SaleCount], [IsSalesCodeKitFlag], [BIOGeneralLedgerID], [EXTGeneralLedgerID], [SURGeneralLedgerID], [BrandID], [Product], [Size], [IsRefundablePayment], [IsNSFChargebackFee], [InterCompanyPrice], [IsQuantityRequired], [XTRGeneralLedgerID], [DescriptionResourceKey], [IsBosleySalesCode], [IsVisibleToConsultant], [IsSerialized], [SerialNumberRegEx], [QuantityPerPack], [PackUnitOfMeasureID], [InventorySalesCodeID], [IsVisibleToClient], [CanBeManagedByClient], [IsManagedByClientOnly], [ClientDescription], [MDPGeneralLedgerID], [PackSKU]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_440C3753
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgSalesCode_CT] c with (nolock)
			where  ( (c.[SalesCodeID] = t.[SalesCodeID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_440C3753, __$count_440C3753, t.[SalesCodeID], t.[SalesCodeSortOrder], t.[SalesCodeDescription], t.[SalesCodeDescriptionShort], t.[SalesCodeTypeID], t.[SalesCodeDepartmentID], t.[VendorID], t.[Barcode], t.[PriceDefault], t.[GLNumber], t.[ServiceDuration], t.[CanScheduleFlag], t.[FactoryOrderFlag], t.[IsRefundableFlag], t.[InventoryFlag], t.[SurgeryCloseoutFlag], t.[TechnicalProfileFlag], t.[AdjustContractPaidAmountFlag], t.[IsPriceAdjustableFlag], t.[IsDiscountableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsARTenderRequiredFlag], t.[CanOrderFlag], t.[IsQuantityAdjustableFlag], t.[IsPhotoEnabledFlag], t.[IsEXTOnlyProductFlag], t.[HairSystemID], t.[SaleCount], t.[IsSalesCodeKitFlag], t.[BIOGeneralLedgerID], t.[EXTGeneralLedgerID], t.[SURGeneralLedgerID], t.[BrandID], t.[Product], t.[Size], t.[IsRefundablePayment], t.[IsNSFChargebackFee], t.[InterCompanyPrice], t.[IsQuantityRequired], t.[XTRGeneralLedgerID], t.[DescriptionResourceKey], t.[IsBosleySalesCode], t.[IsVisibleToConsultant], t.[IsSerialized], t.[SerialNumberRegEx], t.[QuantityPerPack], t.[PackUnitOfMeasureID], t.[InventorySalesCodeID], t.[IsVisibleToClient], t.[CanBeManagedByClient], t.[IsManagedByClientOnly], t.[ClientDescription], t.[MDPGeneralLedgerID], t.[PackSKU]
		from [cdc].[dbo_cfgSalesCode_CT] t with (nolock) inner join
		(	select  r.[SalesCodeID], max(r.__$seqval) as __$max_seqval_440C3753,
		    count(*) as __$count_440C3753
			from [cdc].[dbo_cfgSalesCode_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesCodeID]) m
		on t.__$seqval = m.__$max_seqval_440C3753 and
		    ( (t.[SalesCodeID] = m.[SalesCodeID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgSalesCode_CT] c with (nolock)
							where  ( (c.[SalesCodeID] = t.[SalesCodeID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

	select __$start_lsn,
	    case __$count_440C3753
	    when 1 then __$operation
	    else
			case __$min_op_440C3753
				when 2 then 2
				when 4 then
				case __$operation
					when 1 then 1
					else 4
					end
				else
				case __$operation
					when 2 then 4
					when 4 then 4
					else 1
					end
			end
		end as __$operation,
		case __$count_440C3753
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_440C3753
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [SalesCodeID], [SalesCodeSortOrder], [SalesCodeDescription], [SalesCodeDescriptionShort], [SalesCodeTypeID], [SalesCodeDepartmentID], [VendorID], [Barcode], [PriceDefault], [GLNumber], [ServiceDuration], [CanScheduleFlag], [FactoryOrderFlag], [IsRefundableFlag], [InventoryFlag], [SurgeryCloseoutFlag], [TechnicalProfileFlag], [AdjustContractPaidAmountFlag], [IsPriceAdjustableFlag], [IsDiscountableFlag], [IsActiveFlag], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [IsARTenderRequiredFlag], [CanOrderFlag], [IsQuantityAdjustableFlag], [IsPhotoEnabledFlag], [IsEXTOnlyProductFlag], [HairSystemID], [SaleCount], [IsSalesCodeKitFlag], [BIOGeneralLedgerID], [EXTGeneralLedgerID], [SURGeneralLedgerID], [BrandID], [Product], [Size], [IsRefundablePayment], [IsNSFChargebackFee], [InterCompanyPrice], [IsQuantityRequired], [XTRGeneralLedgerID], [DescriptionResourceKey], [IsBosleySalesCode], [IsVisibleToConsultant], [IsSerialized], [SerialNumberRegEx], [QuantityPerPack], [PackUnitOfMeasureID], [InventorySalesCodeID], [IsVisibleToClient], [CanBeManagedByClient], [IsManagedByClientOnly], [ClientDescription], [MDPGeneralLedgerID], [PackSKU]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_440C3753
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_cfgSalesCode_CT] c with (nolock)
			where  ( (c.[SalesCodeID] = t.[SalesCodeID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_440C3753, __$count_440C3753,
		m.__$update_mask , t.[SalesCodeID], t.[SalesCodeSortOrder], t.[SalesCodeDescription], t.[SalesCodeDescriptionShort], t.[SalesCodeTypeID], t.[SalesCodeDepartmentID], t.[VendorID], t.[Barcode], t.[PriceDefault], t.[GLNumber], t.[ServiceDuration], t.[CanScheduleFlag], t.[FactoryOrderFlag], t.[IsRefundableFlag], t.[InventoryFlag], t.[SurgeryCloseoutFlag], t.[TechnicalProfileFlag], t.[AdjustContractPaidAmountFlag], t.[IsPriceAdjustableFlag], t.[IsDiscountableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsARTenderRequiredFlag], t.[CanOrderFlag], t.[IsQuantityAdjustableFlag], t.[IsPhotoEnabledFlag], t.[IsEXTOnlyProductFlag], t.[HairSystemID], t.[SaleCount], t.[IsSalesCodeKitFlag], t.[BIOGeneralLedgerID], t.[EXTGeneralLedgerID], t.[SURGeneralLedgerID], t.[BrandID], t.[Product], t.[Size], t.[IsRefundablePayment], t.[IsNSFChargebackFee], t.[InterCompanyPrice], t.[IsQuantityRequired], t.[XTRGeneralLedgerID], t.[DescriptionResourceKey], t.[IsBosleySalesCode], t.[IsVisibleToConsultant], t.[IsSerialized], t.[SerialNumberRegEx], t.[QuantityPerPack], t.[PackUnitOfMeasureID], t.[InventorySalesCodeID], t.[IsVisibleToClient], t.[CanBeManagedByClient], t.[IsManagedByClientOnly], t.[ClientDescription], t.[MDPGeneralLedgerID], t.[PackSKU]
		from [cdc].[dbo_cfgSalesCode_CT] t with (nolock) inner join
		(	select  r.[SalesCodeID], max(r.__$seqval) as __$max_seqval_440C3753,
		    count(*) as __$count_440C3753,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_cfgSalesCode_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesCodeID]) m
		on t.__$seqval = m.__$max_seqval_440C3753 and
		    ( (t.[SalesCodeID] = m.[SalesCodeID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgSalesCode_CT] c with (nolock)
							where  ( (c.[SalesCodeID] = t.[SalesCodeID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 			   )
	 			 )
	 			)
	) Q

	union all

		select t.__$start_lsn as __$start_lsn,
		case t.__$operation
			when 1 then 1
			else 5
		end as __$operation,
		null as __$update_mask , t.[SalesCodeID], t.[SalesCodeSortOrder], t.[SalesCodeDescription], t.[SalesCodeDescriptionShort], t.[SalesCodeTypeID], t.[SalesCodeDepartmentID], t.[VendorID], t.[Barcode], t.[PriceDefault], t.[GLNumber], t.[ServiceDuration], t.[CanScheduleFlag], t.[FactoryOrderFlag], t.[IsRefundableFlag], t.[InventoryFlag], t.[SurgeryCloseoutFlag], t.[TechnicalProfileFlag], t.[AdjustContractPaidAmountFlag], t.[IsPriceAdjustableFlag], t.[IsDiscountableFlag], t.[IsActiveFlag], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[IsARTenderRequiredFlag], t.[CanOrderFlag], t.[IsQuantityAdjustableFlag], t.[IsPhotoEnabledFlag], t.[IsEXTOnlyProductFlag], t.[HairSystemID], t.[SaleCount], t.[IsSalesCodeKitFlag], t.[BIOGeneralLedgerID], t.[EXTGeneralLedgerID], t.[SURGeneralLedgerID], t.[BrandID], t.[Product], t.[Size], t.[IsRefundablePayment], t.[IsNSFChargebackFee], t.[InterCompanyPrice], t.[IsQuantityRequired], t.[XTRGeneralLedgerID], t.[DescriptionResourceKey], t.[IsBosleySalesCode], t.[IsVisibleToConsultant], t.[IsSerialized], t.[SerialNumberRegEx], t.[QuantityPerPack], t.[PackUnitOfMeasureID], t.[InventorySalesCodeID], t.[IsVisibleToClient], t.[CanBeManagedByClient], t.[IsManagedByClientOnly], t.[ClientDescription], t.[MDPGeneralLedgerID], t.[PackSKU]
		from [cdc].[dbo_cfgSalesCode_CT] t  with (nolock) inner join
		(	select  r.[SalesCodeID], max(r.__$seqval) as __$max_seqval_440C3753
			from [cdc].[dbo_cfgSalesCode_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesCodeID]) m
		on t.__$seqval = m.__$max_seqval_440C3753 and
		    ( (t.[SalesCodeID] = m.[SalesCodeID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_cfgSalesCode', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_cfgSalesCode_CT] c with (nolock)
							where  ( (c.[SalesCodeID] = t.[SalesCodeID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
