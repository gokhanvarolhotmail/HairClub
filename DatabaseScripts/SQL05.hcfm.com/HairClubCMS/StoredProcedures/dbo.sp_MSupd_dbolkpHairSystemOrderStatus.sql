/* CreateDate: 05/05/2020 17:42:46.257 , ModifyDate: 05/05/2020 17:42:46.257 */
GO
create procedure [sp_MSupd_dbolkpHairSystemOrderStatus]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 bit = NULL,
		@c6 bit = NULL,
		@c7 bit = NULL,
		@c8 bit = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 bit = NULL,
		@c14 bit = NULL,
		@c15 bit = NULL,
		@c16 bit = NULL,
		@c17 bit = NULL,
		@c18 bit = NULL,
		@c19 bit = NULL,
		@c20 bit = NULL,
		@c21 bit = NULL,
		@c22 bit = NULL,
		@c23 nvarchar(100) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[lkpHairSystemOrderStatus] set
		[HairSystemOrderStatusID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [HairSystemOrderStatusID] end,
		[HairSystemOrderStatusSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemOrderStatusSortOrder] end,
		[HairSystemOrderStatusDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderStatusDescription] end,
		[HairSystemOrderStatusDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderStatusDescriptionShort] end,
		[CanApplyFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CanApplyFlag] end,
		[CanTransferFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CanTransferFlag] end,
		[CanEditFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CanEditFlag] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end,
		[CanCancelFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CanCancelFlag] end,
		[IsPreallocationFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsPreallocationFlag] end,
		[CanRedoFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CanRedoFlag] end,
		[CanRepairFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CanRepairFlag] end,
		[ShowInHistoryFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ShowInHistoryFlag] end,
		[CanAddToStockFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CanAddToStockFlag] end,
		[IncludeInMembershipCountFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IncludeInMembershipCountFlag] end,
		[CanRequestCreditFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CanRequestCreditFlag] end,
		[IncludeInInventorySnapshotFlag] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [IncludeInInventorySnapshotFlag] end,
		[IsInTransitFlag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [IsInTransitFlag] end,
		[DescriptionResourceKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [DescriptionResourceKey] end
	where [HairSystemOrderStatusID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderStatusID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemOrderStatus]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[lkpHairSystemOrderStatus] set
		[HairSystemOrderStatusSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemOrderStatusSortOrder] end,
		[HairSystemOrderStatusDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderStatusDescription] end,
		[HairSystemOrderStatusDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderStatusDescriptionShort] end,
		[CanApplyFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CanApplyFlag] end,
		[CanTransferFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CanTransferFlag] end,
		[CanEditFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CanEditFlag] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdateUser] end,
		[CanCancelFlag] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CanCancelFlag] end,
		[IsPreallocationFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsPreallocationFlag] end,
		[CanRedoFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CanRedoFlag] end,
		[CanRepairFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CanRepairFlag] end,
		[ShowInHistoryFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ShowInHistoryFlag] end,
		[CanAddToStockFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CanAddToStockFlag] end,
		[IncludeInMembershipCountFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IncludeInMembershipCountFlag] end,
		[CanRequestCreditFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CanRequestCreditFlag] end,
		[IncludeInInventorySnapshotFlag] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [IncludeInInventorySnapshotFlag] end,
		[IsInTransitFlag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [IsInTransitFlag] end,
		[DescriptionResourceKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [DescriptionResourceKey] end
	where [HairSystemOrderStatusID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderStatusID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpHairSystemOrderStatus]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
