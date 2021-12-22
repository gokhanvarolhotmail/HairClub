create procedure [sp_MSupd_bi_cms_ddsFactSalesTransactionTender]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 money = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 uniqueidentifier = NULL,
		@c14 tinyint = NULL,
		@c15 tinyint = NULL,
		@c16 int = NULL,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@pkc3 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 4 = 4)
begin
update [bi_cms_dds].[FactSalesTransactionTender] set
		[OrderDateKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [OrderDateKey] end,
		[SalesOrderKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesOrderKey] end,
		[SalesOrderTenderKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderTenderKey] end,
		[SalesOrderTypeKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesOrderTypeKey] end,
		[CenterKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CenterKey] end,
		[ClientKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientKey] end,
		[MembershipKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [MembershipKey] end,
		[ClientMembershipKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientMembershipKey] end,
		[TenderTypeKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TenderTypeKey] end,
		[TenderAmount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [TenderAmount] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [msrepl_tran_version] end,
		[IsClosed] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsClosed] end,
		[IsVoided] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsVoided] end,
		[AccountID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AccountID] end
	where [OrderDateKey] = @pkc1
  and [SalesOrderKey] = @pkc2
  and [SalesOrderTenderKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[OrderDateKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[SalesOrderKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[SalesOrderTenderKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[FactSalesTransactionTender]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_cms_dds].[FactSalesTransactionTender] set
		[SalesOrderTypeKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesOrderTypeKey] end,
		[CenterKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CenterKey] end,
		[ClientKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientKey] end,
		[MembershipKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [MembershipKey] end,
		[ClientMembershipKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientMembershipKey] end,
		[TenderTypeKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TenderTypeKey] end,
		[TenderAmount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [TenderAmount] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [msrepl_tran_version] end,
		[IsClosed] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsClosed] end,
		[IsVoided] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsVoided] end,
		[AccountID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AccountID] end
	where [OrderDateKey] = @pkc1
  and [SalesOrderKey] = @pkc2
  and [SalesOrderTenderKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[OrderDateKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[SalesOrderKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[SalesOrderTenderKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[FactSalesTransactionTender]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
