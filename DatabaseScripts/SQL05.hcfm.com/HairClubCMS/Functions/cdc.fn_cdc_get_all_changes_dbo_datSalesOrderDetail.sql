/* CreateDate: 05/05/2020 18:41:00.863 , ModifyDate: 05/05/2020 18:41:00.863 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datSalesOrderDetail]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesOrderDetailGUID], NULL as [TransactionNumber_Temp], NULL as [SalesOrderGUID], NULL as [SalesCodeID], NULL as [Quantity], NULL as [Price], NULL as [Discount], NULL as [Tax1], NULL as [Tax2], NULL as [TaxRate1], NULL as [TaxRate2], NULL as [IsRefundedFlag], NULL as [RefundedSalesOrderDetailGUID], NULL as [RefundedTotalQuantity], NULL as [RefundedTotalPrice], NULL as [Employee1GUID], NULL as [Employee2GUID], NULL as [Employee3GUID], NULL as [Employee4GUID], NULL as [PreviousClientMembershipGUID], NULL as [NewCenterID], NULL as [ExtendedPriceCalc], NULL as [TotalTaxCalc], NULL as [PriceTaxCalc], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [Center_Temp], NULL as [performer_temp], NULL as [performer2_temp], NULL as [Member1Price_temp], NULL as [CancelReasonID], NULL as [EntrySortOrder], NULL as [HairSystemOrderGUID], NULL as [DiscountTypeID], NULL as [BenefitTrackingEnabledFlag], NULL as [MembershipPromotionID], NULL as [MembershipOrderReasonID], NULL as [MembershipNotes], NULL as [GenericSalesCodeDescription], NULL as [SalesCodeSerialNumber], NULL as [WriteOffSalesOrderDetailGUID], NULL as [NSFBouncedDate], NULL as [IsWrittenOffFlag], NULL as [InterCompanyPrice], NULL as [TaxType1ID], NULL as [TaxType2ID], NULL as [ClientMembershipAddOnID], NULL as [NCCMembershipPromotionID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesOrderDetailGUID], t.[TransactionNumber_Temp], t.[SalesOrderGUID], t.[SalesCodeID], t.[Quantity], t.[Price], t.[Discount], t.[Tax1], t.[Tax2], t.[TaxRate1], t.[TaxRate2], t.[IsRefundedFlag], t.[RefundedSalesOrderDetailGUID], t.[RefundedTotalQuantity], t.[RefundedTotalPrice], t.[Employee1GUID], t.[Employee2GUID], t.[Employee3GUID], t.[Employee4GUID], t.[PreviousClientMembershipGUID], t.[NewCenterID], t.[ExtendedPriceCalc], t.[TotalTaxCalc], t.[PriceTaxCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[Center_Temp], t.[performer_temp], t.[performer2_temp], t.[Member1Price_temp], t.[CancelReasonID], t.[EntrySortOrder], t.[HairSystemOrderGUID], t.[DiscountTypeID], t.[BenefitTrackingEnabledFlag], t.[MembershipPromotionID], t.[MembershipOrderReasonID], t.[MembershipNotes], t.[GenericSalesCodeDescription], t.[SalesCodeSerialNumber], t.[WriteOffSalesOrderDetailGUID], t.[NSFBouncedDate], t.[IsWrittenOffFlag], t.[InterCompanyPrice], t.[TaxType1ID], t.[TaxType2ID], t.[ClientMembershipAddOnID], t.[NCCMembershipPromotionID]
	from [cdc].[dbo_datSalesOrderDetail_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesOrderDetailGUID], t.[TransactionNumber_Temp], t.[SalesOrderGUID], t.[SalesCodeID], t.[Quantity], t.[Price], t.[Discount], t.[Tax1], t.[Tax2], t.[TaxRate1], t.[TaxRate2], t.[IsRefundedFlag], t.[RefundedSalesOrderDetailGUID], t.[RefundedTotalQuantity], t.[RefundedTotalPrice], t.[Employee1GUID], t.[Employee2GUID], t.[Employee3GUID], t.[Employee4GUID], t.[PreviousClientMembershipGUID], t.[NewCenterID], t.[ExtendedPriceCalc], t.[TotalTaxCalc], t.[PriceTaxCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[Center_Temp], t.[performer_temp], t.[performer2_temp], t.[Member1Price_temp], t.[CancelReasonID], t.[EntrySortOrder], t.[HairSystemOrderGUID], t.[DiscountTypeID], t.[BenefitTrackingEnabledFlag], t.[MembershipPromotionID], t.[MembershipOrderReasonID], t.[MembershipNotes], t.[GenericSalesCodeDescription], t.[SalesCodeSerialNumber], t.[WriteOffSalesOrderDetailGUID], t.[NSFBouncedDate], t.[IsWrittenOffFlag], t.[InterCompanyPrice], t.[TaxType1ID], t.[TaxType2ID], t.[ClientMembershipAddOnID], t.[NCCMembershipPromotionID]
	from [cdc].[dbo_datSalesOrderDetail_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
