/* CreateDate: 05/05/2020 18:41:00.873 , ModifyDate: 05/05/2020 18:41:00.873 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datSalesOrderDetail]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesOrderDetailGUID], NULL as [TransactionNumber_Temp], NULL as [SalesOrderGUID], NULL as [SalesCodeID], NULL as [Quantity], NULL as [Price], NULL as [Discount], NULL as [Tax1], NULL as [Tax2], NULL as [TaxRate1], NULL as [TaxRate2], NULL as [IsRefundedFlag], NULL as [RefundedSalesOrderDetailGUID], NULL as [RefundedTotalQuantity], NULL as [RefundedTotalPrice], NULL as [Employee1GUID], NULL as [Employee2GUID], NULL as [Employee3GUID], NULL as [Employee4GUID], NULL as [PreviousClientMembershipGUID], NULL as [NewCenterID], NULL as [ExtendedPriceCalc], NULL as [TotalTaxCalc], NULL as [PriceTaxCalc], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [Center_Temp], NULL as [performer_temp], NULL as [performer2_temp], NULL as [Member1Price_temp], NULL as [CancelReasonID], NULL as [EntrySortOrder], NULL as [HairSystemOrderGUID], NULL as [DiscountTypeID], NULL as [BenefitTrackingEnabledFlag], NULL as [MembershipPromotionID], NULL as [MembershipOrderReasonID], NULL as [MembershipNotes], NULL as [GenericSalesCodeDescription], NULL as [SalesCodeSerialNumber], NULL as [WriteOffSalesOrderDetailGUID], NULL as [NSFBouncedDate], NULL as [IsWrittenOffFlag], NULL as [InterCompanyPrice], NULL as [TaxType1ID], NULL as [TaxType2ID], NULL as [ClientMembershipAddOnID], NULL as [NCCMembershipPromotionID]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_5FBEF0C3
	    when 1 then __$operation
	    else
			case __$min_op_5FBEF0C3
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
		null as __$update_mask , [SalesOrderDetailGUID], [TransactionNumber_Temp], [SalesOrderGUID], [SalesCodeID], [Quantity], [Price], [Discount], [Tax1], [Tax2], [TaxRate1], [TaxRate2], [IsRefundedFlag], [RefundedSalesOrderDetailGUID], [RefundedTotalQuantity], [RefundedTotalPrice], [Employee1GUID], [Employee2GUID], [Employee3GUID], [Employee4GUID], [PreviousClientMembershipGUID], [NewCenterID], [ExtendedPriceCalc], [TotalTaxCalc], [PriceTaxCalc], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [Center_Temp], [performer_temp], [performer2_temp], [Member1Price_temp], [CancelReasonID], [EntrySortOrder], [HairSystemOrderGUID], [DiscountTypeID], [BenefitTrackingEnabledFlag], [MembershipPromotionID], [MembershipOrderReasonID], [MembershipNotes], [GenericSalesCodeDescription], [SalesCodeSerialNumber], [WriteOffSalesOrderDetailGUID], [NSFBouncedDate], [IsWrittenOffFlag], [InterCompanyPrice], [TaxType1ID], [TaxType2ID], [ClientMembershipAddOnID], [NCCMembershipPromotionID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5FBEF0C3
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datSalesOrderDetail_CT] c with (nolock)
			where  ( (c.[SalesOrderDetailGUID] = t.[SalesOrderDetailGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_5FBEF0C3, __$count_5FBEF0C3, t.[SalesOrderDetailGUID], t.[TransactionNumber_Temp], t.[SalesOrderGUID], t.[SalesCodeID], t.[Quantity], t.[Price], t.[Discount], t.[Tax1], t.[Tax2], t.[TaxRate1], t.[TaxRate2], t.[IsRefundedFlag], t.[RefundedSalesOrderDetailGUID], t.[RefundedTotalQuantity], t.[RefundedTotalPrice], t.[Employee1GUID], t.[Employee2GUID], t.[Employee3GUID], t.[Employee4GUID], t.[PreviousClientMembershipGUID], t.[NewCenterID], t.[ExtendedPriceCalc], t.[TotalTaxCalc], t.[PriceTaxCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[Center_Temp], t.[performer_temp], t.[performer2_temp], t.[Member1Price_temp], t.[CancelReasonID], t.[EntrySortOrder], t.[HairSystemOrderGUID], t.[DiscountTypeID], t.[BenefitTrackingEnabledFlag], t.[MembershipPromotionID], t.[MembershipOrderReasonID], t.[MembershipNotes], t.[GenericSalesCodeDescription], t.[SalesCodeSerialNumber], t.[WriteOffSalesOrderDetailGUID], t.[NSFBouncedDate], t.[IsWrittenOffFlag], t.[InterCompanyPrice], t.[TaxType1ID], t.[TaxType2ID], t.[ClientMembershipAddOnID], t.[NCCMembershipPromotionID]
		from [cdc].[dbo_datSalesOrderDetail_CT] t with (nolock) inner join
		(	select  r.[SalesOrderDetailGUID], max(r.__$seqval) as __$max_seqval_5FBEF0C3,
		    count(*) as __$count_5FBEF0C3
			from [cdc].[dbo_datSalesOrderDetail_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesOrderDetailGUID]) m
		on t.__$seqval = m.__$max_seqval_5FBEF0C3 and
		    ( (t.[SalesOrderDetailGUID] = m.[SalesOrderDetailGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datSalesOrderDetail_CT] c with (nolock)
							where  ( (c.[SalesOrderDetailGUID] = t.[SalesOrderDetailGUID]) )
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
	    case __$count_5FBEF0C3
	    when 1 then __$operation
	    else
			case __$min_op_5FBEF0C3
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
		case __$count_5FBEF0C3
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_5FBEF0C3
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [SalesOrderDetailGUID], [TransactionNumber_Temp], [SalesOrderGUID], [SalesCodeID], [Quantity], [Price], [Discount], [Tax1], [Tax2], [TaxRate1], [TaxRate2], [IsRefundedFlag], [RefundedSalesOrderDetailGUID], [RefundedTotalQuantity], [RefundedTotalPrice], [Employee1GUID], [Employee2GUID], [Employee3GUID], [Employee4GUID], [PreviousClientMembershipGUID], [NewCenterID], [ExtendedPriceCalc], [TotalTaxCalc], [PriceTaxCalc], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [Center_Temp], [performer_temp], [performer2_temp], [Member1Price_temp], [CancelReasonID], [EntrySortOrder], [HairSystemOrderGUID], [DiscountTypeID], [BenefitTrackingEnabledFlag], [MembershipPromotionID], [MembershipOrderReasonID], [MembershipNotes], [GenericSalesCodeDescription], [SalesCodeSerialNumber], [WriteOffSalesOrderDetailGUID], [NSFBouncedDate], [IsWrittenOffFlag], [InterCompanyPrice], [TaxType1ID], [TaxType2ID], [ClientMembershipAddOnID], [NCCMembershipPromotionID]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_5FBEF0C3
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datSalesOrderDetail_CT] c with (nolock)
			where  ( (c.[SalesOrderDetailGUID] = t.[SalesOrderDetailGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_5FBEF0C3, __$count_5FBEF0C3,
		m.__$update_mask , t.[SalesOrderDetailGUID], t.[TransactionNumber_Temp], t.[SalesOrderGUID], t.[SalesCodeID], t.[Quantity], t.[Price], t.[Discount], t.[Tax1], t.[Tax2], t.[TaxRate1], t.[TaxRate2], t.[IsRefundedFlag], t.[RefundedSalesOrderDetailGUID], t.[RefundedTotalQuantity], t.[RefundedTotalPrice], t.[Employee1GUID], t.[Employee2GUID], t.[Employee3GUID], t.[Employee4GUID], t.[PreviousClientMembershipGUID], t.[NewCenterID], t.[ExtendedPriceCalc], t.[TotalTaxCalc], t.[PriceTaxCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[Center_Temp], t.[performer_temp], t.[performer2_temp], t.[Member1Price_temp], t.[CancelReasonID], t.[EntrySortOrder], t.[HairSystemOrderGUID], t.[DiscountTypeID], t.[BenefitTrackingEnabledFlag], t.[MembershipPromotionID], t.[MembershipOrderReasonID], t.[MembershipNotes], t.[GenericSalesCodeDescription], t.[SalesCodeSerialNumber], t.[WriteOffSalesOrderDetailGUID], t.[NSFBouncedDate], t.[IsWrittenOffFlag], t.[InterCompanyPrice], t.[TaxType1ID], t.[TaxType2ID], t.[ClientMembershipAddOnID], t.[NCCMembershipPromotionID]
		from [cdc].[dbo_datSalesOrderDetail_CT] t with (nolock) inner join
		(	select  r.[SalesOrderDetailGUID], max(r.__$seqval) as __$max_seqval_5FBEF0C3,
		    count(*) as __$count_5FBEF0C3,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datSalesOrderDetail_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesOrderDetailGUID]) m
		on t.__$seqval = m.__$max_seqval_5FBEF0C3 and
		    ( (t.[SalesOrderDetailGUID] = m.[SalesOrderDetailGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datSalesOrderDetail_CT] c with (nolock)
							where  ( (c.[SalesOrderDetailGUID] = t.[SalesOrderDetailGUID]) )
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
		null as __$update_mask , t.[SalesOrderDetailGUID], t.[TransactionNumber_Temp], t.[SalesOrderGUID], t.[SalesCodeID], t.[Quantity], t.[Price], t.[Discount], t.[Tax1], t.[Tax2], t.[TaxRate1], t.[TaxRate2], t.[IsRefundedFlag], t.[RefundedSalesOrderDetailGUID], t.[RefundedTotalQuantity], t.[RefundedTotalPrice], t.[Employee1GUID], t.[Employee2GUID], t.[Employee3GUID], t.[Employee4GUID], t.[PreviousClientMembershipGUID], t.[NewCenterID], t.[ExtendedPriceCalc], t.[TotalTaxCalc], t.[PriceTaxCalc], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[Center_Temp], t.[performer_temp], t.[performer2_temp], t.[Member1Price_temp], t.[CancelReasonID], t.[EntrySortOrder], t.[HairSystemOrderGUID], t.[DiscountTypeID], t.[BenefitTrackingEnabledFlag], t.[MembershipPromotionID], t.[MembershipOrderReasonID], t.[MembershipNotes], t.[GenericSalesCodeDescription], t.[SalesCodeSerialNumber], t.[WriteOffSalesOrderDetailGUID], t.[NSFBouncedDate], t.[IsWrittenOffFlag], t.[InterCompanyPrice], t.[TaxType1ID], t.[TaxType2ID], t.[ClientMembershipAddOnID], t.[NCCMembershipPromotionID]
		from [cdc].[dbo_datSalesOrderDetail_CT] t  with (nolock) inner join
		(	select  r.[SalesOrderDetailGUID], max(r.__$seqval) as __$max_seqval_5FBEF0C3
			from [cdc].[dbo_datSalesOrderDetail_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesOrderDetailGUID]) m
		on t.__$seqval = m.__$max_seqval_5FBEF0C3 and
		    ( (t.[SalesOrderDetailGUID] = m.[SalesOrderDetailGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderDetail', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datSalesOrderDetail_CT] c with (nolock)
							where  ( (c.[SalesOrderDetailGUID] = t.[SalesOrderDetailGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
