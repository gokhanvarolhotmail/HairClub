/* CreateDate: 03/17/2022 11:57:04.490 , ModifyDate: 03/17/2022 11:57:04.490 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimAccumulatorAdjustment]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 int = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 int = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 varchar(50) = NULL,
		@c12 varchar(10) = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 money = NULL,
		@c18 money = NULL,
		@c19 date = NULL,
		@c20 date = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 money = NULL,
		@c26 money = NULL,
		@c27 tinyint = NULL,
		@c28 datetime = NULL,
		@c29 datetime = NULL,
		@c30 varchar(200) = NULL,
		@c31 tinyint = NULL,
		@c32 int = NULL,
		@c33 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimAccumulatorAdjustment] set
		[AccumulatorAdjustmentSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccumulatorAdjustmentSSID] end,
		[ClientMembershipKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientMembershipKey] end,
		[ClientMembershipSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientMembershipSSID] end,
		[SalesOrderDetailKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalesOrderDetailKey] end,
		[SalesOrderDetailSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesOrderDetailSSID] end,
		[AppointmentKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AppointmentKey] end,
		[AppointmentSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AppointmentSSID] end,
		[AccumulatorKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [AccumulatorKey] end,
		[AccumulatorSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AccumulatorSSID] end,
		[AccumulatorDescription] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AccumulatorDescription] end,
		[AccumulatorDescriptionShort] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AccumulatorDescriptionShort] end,
		[QuantityUsedOriginal] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [QuantityUsedOriginal] end,
		[QuantityUsedAdjustment] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [QuantityUsedAdjustment] end,
		[QuantityTotalOriginal] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [QuantityTotalOriginal] end,
		[QuantityTotalAdjustment] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [QuantityTotalAdjustment] end,
		[MoneyOriginal] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [MoneyOriginal] end,
		[MoneyAdjustment] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [MoneyAdjustment] end,
		[DateOriginal] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [DateOriginal] end,
		[DateAdjustment] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [DateAdjustment] end,
		[QuantityUsedNew] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [QuantityUsedNew] end,
		[QuantityUsedChange] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [QuantityUsedChange] end,
		[QuantityTotalNew] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [QuantityTotalNew] end,
		[QuantityTotalChange] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [QuantityTotalChange] end,
		[MoneyNew] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [MoneyNew] end,
		[MoneyChange] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [MoneyChange] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [UpdateAuditKey] end
	where [AccumulatorAdjustmentKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccumulatorAdjustmentKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimAccumulatorAdjustment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
