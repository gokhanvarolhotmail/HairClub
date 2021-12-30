/* CreateDate: 05/05/2020 17:42:48.647 , ModifyDate: 05/05/2020 17:42:48.647 */
GO
create procedure [sp_MSupd_dbodatClientAddress]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 int = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 int = NULL,
		@c10 nvarchar(10) = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(25) = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datClientAddress] set
		[ClientAddressGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ClientAddressGUID] end,
		[ClientAddressTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientAddressTypeID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientGUID] end,
		[CountryID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CountryID] end,
		[Address1] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Address1] end,
		[Address2] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Address2] end,
		[Address3] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Address3] end,
		[City] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [City] end,
		[StateID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [StateID] end,
		[PostalCode] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PostalCode] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end
	where [ClientAddressGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientAddressGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientAddress]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datClientAddress] set
		[ClientAddressTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientAddressTypeID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientGUID] end,
		[CountryID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CountryID] end,
		[Address1] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Address1] end,
		[Address2] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Address2] end,
		[Address3] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Address3] end,
		[City] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [City] end,
		[StateID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [StateID] end,
		[PostalCode] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [PostalCode] end,
		[CreateDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [LastUpdateUser] end
	where [ClientAddressGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ClientAddressGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datClientAddress]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
