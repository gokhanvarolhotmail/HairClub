/* CreateDate: 05/05/2020 17:42:50.423 , ModifyDate: 05/05/2020 17:42:50.423 */
GO
create procedure [sp_MSupd_dbodatInventoryTransferRequest]
		@c1 uniqueidentifier = NULL,
		@c2 datetime = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 bit = NULL,
		@c6 int = NULL,
		@c7 uniqueidentifier = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 uniqueidentifier = NULL,
		@c11 uniqueidentifier = NULL,
		@c12 text = NULL,
		@c13 datetime = NULL,
		@c14 datetime = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datInventoryTransferRequest] set
		[InventoryTransferRequestGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [InventoryTransferRequestGUID] end,
		[InventoryTransferRequestDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [InventoryTransferRequestDate] end,
		[InventoryTransferRequestStatusID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [InventoryTransferRequestStatusID] end,
		[InventoryTransferRequestRejectReasonID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InventoryTransferRequestRejectReasonID] end,
		[IsRejectedFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsRejectedFlag] end,
		[OriginalHairSystemOrderStatusID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [OriginalHairSystemOrderStatusID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemOrderGUID] end,
		[FromCenterID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [FromCenterID] end,
		[ToCenterID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ToCenterID] end,
		[FromClientMembershipGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [FromClientMembershipGUID] end,
		[ToClientMembershipGUID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ToClientMembershipGUID] end,
		[InventoryTransferRequestNote] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InventoryTransferRequestNote] end,
		[LastStatusChangeDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastStatusChangeDate] end,
		[CompleteDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CompleteDate] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end
	where [InventoryTransferRequestGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[InventoryTransferRequestGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datInventoryTransferRequest]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datInventoryTransferRequest] set
		[InventoryTransferRequestDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [InventoryTransferRequestDate] end,
		[InventoryTransferRequestStatusID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [InventoryTransferRequestStatusID] end,
		[InventoryTransferRequestRejectReasonID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InventoryTransferRequestRejectReasonID] end,
		[IsRejectedFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsRejectedFlag] end,
		[OriginalHairSystemOrderStatusID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [OriginalHairSystemOrderStatusID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemOrderGUID] end,
		[FromCenterID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [FromCenterID] end,
		[ToCenterID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ToCenterID] end,
		[FromClientMembershipGUID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [FromClientMembershipGUID] end,
		[ToClientMembershipGUID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ToClientMembershipGUID] end,
		[InventoryTransferRequestNote] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [InventoryTransferRequestNote] end,
		[LastStatusChangeDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastStatusChangeDate] end,
		[CompleteDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CompleteDate] end,
		[CreateDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastUpdateUser] end
	where [InventoryTransferRequestGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[InventoryTransferRequestGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datInventoryTransferRequest]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
