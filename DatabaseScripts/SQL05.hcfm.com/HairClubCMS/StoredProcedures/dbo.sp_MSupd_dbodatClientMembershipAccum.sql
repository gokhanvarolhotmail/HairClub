/* CreateDate: 05/05/2020 17:42:49.320 , ModifyDate: 05/05/2020 17:42:49.320 */
GO
create procedure [sp_MSupd_dbodatClientMembershipAccum]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 decimal(21,6) = NULL,
		@c6 datetime = NULL,
		@c7 int = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datClientMembershipAccum] set
		[ClientMembershipAccumGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ClientMembershipAccumGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipGUID] end,
		[AccumulatorID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccumulatorID] end,
		[UsedAccumQuantity] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [UsedAccumQuantity] end,
		[AccumMoney] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumMoney] end,
		[AccumDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AccumDate] end,
		[TotalAccumQuantity] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [TotalAccumQuantity] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ClientMembershipAddOnID] end
	where [ClientMembershipAccumGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipAccumGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientMembershipAccum]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datClientMembershipAccum] set
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipGUID] end,
		[AccumulatorID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccumulatorID] end,
		[UsedAccumQuantity] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [UsedAccumQuantity] end,
		[AccumMoney] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumMoney] end,
		[AccumDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AccumDate] end,
		[TotalAccumQuantity] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [TotalAccumQuantity] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ClientMembershipAddOnID] end
	where [ClientMembershipAccumGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientMembershipAccumGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientMembershipAccum]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
