/* CreateDate: 05/05/2020 17:42:37.447 , ModifyDate: 05/05/2020 17:42:37.447 */
GO
create procedure [sp_MSupd_dbocfgAccumulator]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 bit = NULL,
		@c7 bit = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 bit = NULL,
		@c11 bit = NULL,
		@c12 bit = NULL,
		@c13 bit = NULL,
		@c14 bit = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 bit = NULL,
		@c20 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgAccumulator] set
		[AccumulatorSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccumulatorSortOrder] end,
		[AccumulatorDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccumulatorDescription] end,
		[AccumulatorDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AccumulatorDescriptionShort] end,
		[AccumulatorDataTypeID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumulatorDataTypeID] end,
		[SalesOrderProcessFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesOrderProcessFlag] end,
		[SchedulerProcessFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SchedulerProcessFlag] end,
		[SchedulerActionTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SchedulerActionTypeID] end,
		[SchedulerAdjustmentTypeID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SchedulerAdjustmentTypeID] end,
		[AdjustARBalanceFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AdjustARBalanceFlag] end,
		[AdjustContractPriceFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AdjustContractPriceFlag] end,
		[AdjustContractPaidFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AdjustContractPaidFlag] end,
		[IsVisibleFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsVisibleFlag] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end,
		[IsVisibleToClient] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsVisibleToClient] end,
		[ClientDescription] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ClientDescription] end
	where [AccumulatorID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccumulatorID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgAccumulator]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
