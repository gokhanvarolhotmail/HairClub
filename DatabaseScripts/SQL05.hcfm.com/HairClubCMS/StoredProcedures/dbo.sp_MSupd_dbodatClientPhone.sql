/* CreateDate: 05/05/2020 17:42:49.370 , ModifyDate: 05/05/2020 17:42:49.370 */
GO
create procedure [dbo].[sp_MSupd_dbodatClientPhone]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 nvarchar(15) = NULL,
		@c5 bit = NULL,
		@c6 bit = NULL,
		@c7 bit = NULL,
		@c8 bit = NULL,
		@c9 int = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datClientPhone] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[PhoneTypeID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PhoneTypeID] end,
		[PhoneNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [PhoneNumber] end,
		[CanConfirmAppointmentByCall] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CanConfirmAppointmentByCall] end,
		[CanConfirmAppointmentByText] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CanConfirmAppointmentByText] end,
		[CanContactForPromotionsByCall] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CanContactForPromotionsByCall] end,
		[CanContactForPromotionsByText] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CanContactForPromotionsByText] end,
		[ClientPhoneSortOrder] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ClientPhoneSortOrder] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [UpdateStamp] end
	where [ClientPhoneID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientPhoneID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientPhone]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
