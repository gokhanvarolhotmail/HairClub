/* CreateDate: 05/05/2020 17:42:51.453 , ModifyDate: 05/05/2020 17:42:51.453 */
GO
create procedure [sp_MSupd_dbodatNotification]
		@c1 int = NULL,
		@c2 datetime = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 int = NULL,
		@c6 date = NULL,
		@c7 int = NULL,
		@c8 bit = NULL,
		@c9 nvarchar(200) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 uniqueidentifier = NULL,
		@c15 bit = NULL,
		@c16 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datNotification] set
		[NotificationDate] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [NotificationDate] end,
		[NotificationTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [NotificationTypeID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientGUID] end,
		[FeePayCycleID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FeePayCycleID] end,
		[FeeDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [FeeDate] end,
		[CenterID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CenterID] end,
		[IsAcknowledgedFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsAcknowledgedFlag] end,
		[Description] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Description] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[AppointmentGUID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [AppointmentGUID] end,
		[IsHairOrderRequestedFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsHairOrderRequestedFlag] end,
		[VisitingCenterID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [VisitingCenterID] end
	where [NotificationID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[NotificationID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datNotification]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
