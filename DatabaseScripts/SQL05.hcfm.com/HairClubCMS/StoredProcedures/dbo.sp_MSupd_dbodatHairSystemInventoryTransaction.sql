/* CreateDate: 05/05/2020 17:42:50.210 , ModifyDate: 05/05/2020 17:42:50.210 */
GO
create procedure [sp_MSupd_dbodatHairSystemInventoryTransaction]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 int = NULL,
		@c6 bit = NULL,
		@c7 uniqueidentifier = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 datetime = NULL,
		@c12 uniqueidentifier = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 bit = NULL,
		@c16 nvarchar(200) = NULL,
		@c17 datetime = NULL,
		@c18 nvarchar(25) = NULL,
		@c19 datetime = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datHairSystemInventoryTransaction] set
		[HairSystemInventoryBatchID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemInventoryBatchID] end,
		[HairSystemOrderGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemOrderGUID] end,
		[HairSystemOrderNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemOrderNumber] end,
		[HairSystemOrderStatusID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemOrderStatusID] end,
		[IsInTransit] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsInTransit] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientMembershipGUID] end,
		[ClientIdentifier] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ClientIdentifier] end,
		[ClientHomeCenterID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ClientHomeCenterID] end,
		[ScannedDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ScannedDate] end,
		[ScannedEmployeeGUID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ScannedEmployeeGUID] end,
		[ScannedCenterID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ScannedCenterID] end,
		[ScannedHairSystemInventoryBatchID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ScannedHairSystemInventoryBatchID] end,
		[IsExcludedFromCorrections] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsExcludedFromCorrections] end,
		[ExclusionReason] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ExclusionReason] end,
		[CreateDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastUpdateUser] end,
		[IsScannedEntry] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [IsScannedEntry] end
	where [HairSystemInventoryTransactionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemInventoryTransactionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemInventoryTransaction]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
