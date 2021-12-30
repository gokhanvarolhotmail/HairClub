/* CreateDate: 05/05/2020 18:41:01.087 , ModifyDate: 05/05/2020 18:41:01.087 */
GO
create function [cdc].[fn_cdc_get_all_changes_dbo_datSalesOrderTender]
	(	@from_lsn binary(10),
		@to_lsn binary(10),
		@row_filter_option nvarchar(30)
	)
	returns table
	return

	select NULL as __$start_lsn,
		NULL as __$seqval,
		NULL as __$operation,
		NULL as __$update_mask, NULL as [SalesOrderTenderGUID], NULL as [SalesOrderGUID], NULL as [TenderTypeID], NULL as [Amount], NULL as [CheckNumber], NULL as [CreditCardLast4Digits], NULL as [ApprovalCode], NULL as [CreditCardTypeID], NULL as [FinanceCompanyID], NULL as [InterCompanyReasonID], NULL as [CreateDate], NULL as [CreateUser], NULL as [LastUpdate], NULL as [LastUpdateUser], NULL as [UpdateStamp], NULL as [RefundAmount], NULL as [MonetraTransactionId], NULL as [EntrySortOrder], NULL as [CashCollected]
	where ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 0)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesOrderTenderGUID], t.[SalesOrderGUID], t.[TenderTypeID], t.[Amount], t.[CheckNumber], t.[CreditCardLast4Digits], t.[ApprovalCode], t.[CreditCardTypeID], t.[FinanceCompanyID], t.[InterCompanyReasonID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[RefundAmount], t.[MonetraTransactionId], t.[EntrySortOrder], t.[CashCollected]
	from [cdc].[dbo_datSalesOrderTender_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4)
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)

	union all

	select t.__$start_lsn as __$start_lsn,
		t.__$seqval as __$seqval,
		t.__$operation as __$operation,
		t.__$update_mask as __$update_mask, t.[SalesOrderTenderGUID], t.[SalesOrderGUID], t.[TenderTypeID], t.[Amount], t.[CheckNumber], t.[CreditCardLast4Digits], t.[ApprovalCode], t.[CreditCardTypeID], t.[FinanceCompanyID], t.[InterCompanyReasonID], t.[CreateDate], t.[CreateUser], t.[LastUpdate], t.[LastUpdateUser], t.[UpdateStamp], t.[RefundAmount], t.[MonetraTransactionId], t.[EntrySortOrder], t.[CashCollected]
	from [cdc].[dbo_datSalesOrderTender_CT] t with (nolock)
	where (lower(rtrim(ltrim(@row_filter_option))) = 'all update old')
	    and ( [sys].[fn_cdc_check_parameters]( N'dbo_datSalesOrderTender', @from_lsn, @to_lsn, lower(rtrim(ltrim(@row_filter_option))), 0) = 1)
		and (t.__$operation = 1 or t.__$operation = 2 or t.__$operation = 4 or
		     t.__$operation = 3 )
		and (t.__$start_lsn <= @to_lsn)
		and (t.__$start_lsn >= @from_lsn)
GO
