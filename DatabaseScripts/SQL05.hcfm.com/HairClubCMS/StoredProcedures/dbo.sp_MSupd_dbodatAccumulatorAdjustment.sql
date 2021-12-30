/* CreateDate: 05/05/2020 17:42:48.457 , ModifyDate: 05/05/2020 17:42:48.457 */
GO
create procedure [sp_MSupd_dbodatAccumulatorAdjustment]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 decimal(21,6) = NULL,
		@c12 decimal(21,6) = NULL,
		@c13 date = NULL,
		@c14 date = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 uniqueidentifier = NULL,
		@c20 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datAccumulatorAdjustment] set
		[AccumulatorAdjustmentGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AccumulatorAdjustmentGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipGUID] end,
		[SalesOrderDetailGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderDetailGUID] end,
		[AppointmentGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AppointmentGUID] end,
		[AccumulatorID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumulatorID] end,
		[AccumulatorActionTypeID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AccumulatorActionTypeID] end,
		[QuantityUsedOriginal] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [QuantityUsedOriginal] end,
		[QuantityUsedAdjustment] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [QuantityUsedAdjustment] end,
		[QuantityTotalOriginal] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [QuantityTotalOriginal] end,
		[QuantityTotalAdjustment] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [QuantityTotalAdjustment] end,
		[MoneyOriginal] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MoneyOriginal] end,
		[MoneyAdjustment] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MoneyAdjustment] end,
		[DateOriginal] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [DateOriginal] end,
		[DateAdjustment] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [DateAdjustment] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end,
		[SalesOrderTenderGuid] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SalesOrderTenderGuid] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ClientMembershipAddOnID] end
	where [AccumulatorAdjustmentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccumulatorAdjustmentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccumulatorAdjustment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datAccumulatorAdjustment] set
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientMembershipGUID] end,
		[SalesOrderDetailGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesOrderDetailGUID] end,
		[AppointmentGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AppointmentGUID] end,
		[AccumulatorID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumulatorID] end,
		[AccumulatorActionTypeID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AccumulatorActionTypeID] end,
		[QuantityUsedOriginal] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [QuantityUsedOriginal] end,
		[QuantityUsedAdjustment] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [QuantityUsedAdjustment] end,
		[QuantityTotalOriginal] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [QuantityTotalOriginal] end,
		[QuantityTotalAdjustment] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [QuantityTotalAdjustment] end,
		[MoneyOriginal] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MoneyOriginal] end,
		[MoneyAdjustment] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [MoneyAdjustment] end,
		[DateOriginal] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [DateOriginal] end,
		[DateAdjustment] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [DateAdjustment] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end,
		[SalesOrderTenderGuid] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SalesOrderTenderGuid] end,
		[ClientMembershipAddOnID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ClientMembershipAddOnID] end
	where [AccumulatorAdjustmentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccumulatorAdjustmentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAccumulatorAdjustment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
