create procedure [sp_MSupd_bi_cms_ddsDimClientMembershipAccum]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 varchar(50) = NULL,
		@c8 varchar(10) = NULL,
		@c9 int = NULL,
		@c10 money = NULL,
		@c11 datetime = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 tinyint = NULL,
		@c15 datetime = NULL,
		@c16 datetime = NULL,
		@c17 varchar(200) = NULL,
		@c18 tinyint = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimClientMembershipAccum] set
		[ClientMembershipAccumSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipAccumSSID] end,
		[ClientMembershipKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientMembershipKey] end,
		[ClientMembershipSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientMembershipSSID] end,
		[AccumulatorKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumulatorKey] end,
		[AccumulatorSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AccumulatorSSID] end,
		[AccumulatorDescription] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AccumulatorDescription] end,
		[AccumulatorDescriptionShort] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AccumulatorDescriptionShort] end,
		[UsedAccumQuantity] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UsedAccumQuantity] end,
		[AccumMoney] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AccumMoney] end,
		[AccumDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AccumDate] end,
		[TotalAccumQuantity] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [TotalAccumQuantity] end,
		[AccumQuantityRemaining] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [AccumQuantityRemaining] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [UpdateAuditKey] end
	where [ClientMembershipAccumKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipAccumKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimClientMembershipAccum]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
