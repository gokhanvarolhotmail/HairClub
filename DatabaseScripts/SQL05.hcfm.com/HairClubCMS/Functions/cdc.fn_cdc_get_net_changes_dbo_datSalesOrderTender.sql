/* CreateDate: 05/05/2020 18:41:01.093 , ModifyDate: 05/05/2020 18:41:01.093 */
GO
create function [cdc].[fn_cdc_get_net_changes_dbo_datSalesOrderTender]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesOrderTenderGUID], NULL as [SalesOrderGUID], NULL as [TenderTypeID], NULL as [Amount], NULL as [CheckNumber], NULL as [CreditCardLast4Digits], NULL as [ApprovalCode], NULL as [CreditCardTypeID], NULL as [FinanceCompanyID], NULL as [InterCompanyReasonID], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [RefundAmount], NULL as [MonetraTransactionId], NULL as [EntrySortOrder], NULL as [CashCollected]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 0)

	union all

	select __$start_lsn,
	    case __$count_F8C1CE96
	    when 1 then __$operation
	    else
			case __$min_op_F8C1CE96
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
		null as __$update_mask , [SalesOrderTenderGUID], [SalesOrderGUID], [TenderTypeID], [Amount], [CheckNumber], [CreditCardLast4Digits], [ApprovalCode], [CreditCardTypeID], [FinanceCompanyID], [InterCompanyReasonID], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [RefundAmount], [MonetraTransactionId], [EntrySortOrder], [CashCollected]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_F8C1CE96
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datSalesOrderTender_CT] c with (nolock)
			where  ( (c.[SalesOrderTenderGUID] = t.[SalesOrderTenderGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_F8C1CE96, __$count_F8C1CE96, t.[SalesOrderTenderGUID], t.[SalesOrderGUID], t.[TenderTypeID], t.[Amount], t.[CheckNumber], t.[CreditCardLast4Digits], t.[ApprovalCode], t.[CreditCardTypeID], t.[FinanceCompanyID], t.[InterCompanyReasonID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[RefundAmount], t.[MonetraTransactionId], t.[EntrySortOrder], t.[CashCollected]
		from [cdc].[dbo_datSalesOrderTender_CT] t with (nolock) inner join
		(	select  r.[SalesOrderTenderGUID], max(r.__$seqval) as __$max_seqval_F8C1CE96,
		    count(*) as __$count_F8C1CE96
			from [cdc].[dbo_datSalesOrderTender_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesOrderTenderGUID]) m
		on t.__$seqval = m.__$max_seqval_F8C1CE96 and
		    ( (t.[SalesOrderTenderGUID] = m.[SalesOrderTenderGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datSalesOrderTender_CT] c with (nolock)
							where  ( (c.[SalesOrderTenderGUID] = t.[SalesOrderTenderGUID]) )
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
	    case __$count_F8C1CE96
	    when 1 then __$operation
	    else
			case __$min_op_F8C1CE96
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
		case __$count_F8C1CE96
		when 1 then
			case __$operation
			when 4 then __$update_mask
			else null
			end
		else
			case __$min_op_F8C1CE96
			when 2 then null
			else
				case __$operation
				when 1 then null
				else __$update_mask
				end
			end
		end as __$update_mask , [SalesOrderTenderGUID], [SalesOrderGUID], [TenderTypeID], [Amount], [CheckNumber], [CreditCardLast4Digits], [ApprovalCode], [CreditCardTypeID], [FinanceCompanyID], [InterCompanyReasonID], [CreateDate], [CreateUser], [LastUpdate], [LastUpdateUser], [UpdateStamp], [RefundAmount], [MonetraTransactionId], [EntrySortOrder], [CashCollected]
	from
	(
		select t.__$start_lsn as __$start_lsn, __$operation,
		case __$count_F8C1CE96
		when 1 then __$operation
		else
		(	select top 1 c.__$operation
			from [cdc].[dbo_datSalesOrderTender_CT] c with (nolock)
			where  ( (c.[SalesOrderTenderGUID] = t.[SalesOrderTenderGUID]) )
			and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
			and (c.__$start_lsn <= @to_lsn)
			and (c.__$start_lsn >= @from_lsn)
			order by c.__$seqval) end __$min_op_F8C1CE96, __$count_F8C1CE96,
		m.__$update_mask , t.[SalesOrderTenderGUID], t.[SalesOrderGUID], t.[TenderTypeID], t.[Amount], t.[CheckNumber], t.[CreditCardLast4Digits], t.[ApprovalCode], t.[CreditCardTypeID], t.[FinanceCompanyID], t.[InterCompanyReasonID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[RefundAmount], t.[MonetraTransactionId], t.[EntrySortOrder], t.[CashCollected]
		from [cdc].[dbo_datSalesOrderTender_CT] t with (nolock) inner join
		(	select  r.[SalesOrderTenderGUID], max(r.__$seqval) as __$max_seqval_F8C1CE96,
		    count(*) as __$count_F8C1CE96,
		    [sys].[ORMask](r.__$update_mask) as __$update_mask
			from [cdc].[dbo_datSalesOrderTender_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesOrderTenderGUID]) m
		on t.__$seqval = m.__$max_seqval_F8C1CE96 and
		    ( (t.[SalesOrderTenderGUID] = m.[SalesOrderTenderGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with mask'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				  (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datSalesOrderTender_CT] c with (nolock)
							where  ( (c.[SalesOrderTenderGUID] = t.[SalesOrderTenderGUID]) )
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
		null as __$update_mask , t.[SalesOrderTenderGUID], t.[SalesOrderGUID], t.[TenderTypeID], t.[Amount], t.[CheckNumber], t.[CreditCardLast4Digits], t.[ApprovalCode], t.[CreditCardTypeID], t.[FinanceCompanyID], t.[InterCompanyReasonID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[RefundAmount], t.[MonetraTransactionId], t.[EntrySortOrder], t.[CashCollected]
		from [cdc].[dbo_datSalesOrderTender_CT] t  with (nolock) inner join
		(	select  r.[SalesOrderTenderGUID], max(r.__$seqval) as __$max_seqval_F8C1CE96
			from [cdc].[dbo_datSalesOrderTender_CT] r with (nolock)
			where  (r.__$start_lsn <= @to_lsn)
			and (r.__$start_lsn >= @from_lsn)
			group by   r.[SalesOrderTenderGUID]) m
		on t.__$seqval = m.__$max_seqval_F8C1CE96 and
		    ( (t.[SalesOrderTenderGUID] = m.[SalesOrderTenderGUID]) )
		where lower(rtrim(ltrim(@row_filter_option))) = N'all with merge'
			and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 1) = 1)
			and (t.__$start_lsn <= @to_lsn)
			and (t.__$start_lsn >= @from_lsn)
			and ((t.__$operation = 2) or (t.__$operation = 4) or
				 ((t.__$operation = 1) and
				   (2 not in
				 		(	select top 1 c.__$operation
							from [cdc].[dbo_datSalesOrderTender_CT] c with (nolock)
							where  ( (c.[SalesOrderTenderGUID] = t.[SalesOrderTenderGUID]) )
							and ((c.__$operation = 2) or (c.__$operation = 4) or (c.__$operation = 1))
							and (c.__$start_lsn <= @to_lsn)
							and (c.__$start_lsn >= @from_lsn)
							order by c.__$seqval
						 )
	 				)
	 			 )
	 			)
GO
