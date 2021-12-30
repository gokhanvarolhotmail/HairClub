/* CreateDate: 05/05/2020 17:42:38.857 , ModifyDate: 05/05/2020 17:42:38.857 */
GO
create procedure [sp_MSupd_dbolkpCountry]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 bit = NULL,
		@c7 bit = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 bit = NULL,
		@c13 bit = NULL,
		@c14 bit = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 nvarchar(500) = NULL,
		@c17 nvarchar(100) = NULL,
		@c18 nvarchar(10) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[lkpCountry] set
		[CountryID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CountryID] end,
		[CountrySortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CountrySortOrder] end,
		[CountryDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CountryDescription] end,
		[CountryDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CountryDescriptionShort] end,
		[CurrencyTypeID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CurrencyTypeID] end,
		[ValidateZipCodeFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ValidateZipCodeFlag] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[IsStateEnabled] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsStateEnabled] end,
		[IsAddressRequired] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsAddressRequired] end,
		[IsPhoneNumberRequired] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsPhoneNumberRequired] end,
		[PhoneNumberMask] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PhoneNumberMask] end,
		[PhoneNumberValidationRegEx] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PhoneNumberValidationRegEx] end,
		[PhoneNumberDisplayFormat] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PhoneNumberDisplayFormat] end,
		[PhoneCountryCode] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [PhoneCountryCode] end
	where [CountryID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CountryID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpCountry]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[lkpCountry] set
		[CountrySortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CountrySortOrder] end,
		[CountryDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CountryDescription] end,
		[CountryDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CountryDescriptionShort] end,
		[CurrencyTypeID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CurrencyTypeID] end,
		[ValidateZipCodeFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ValidateZipCodeFlag] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastUpdateUser] end,
		[IsStateEnabled] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsStateEnabled] end,
		[IsAddressRequired] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [IsAddressRequired] end,
		[IsPhoneNumberRequired] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsPhoneNumberRequired] end,
		[PhoneNumberMask] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PhoneNumberMask] end,
		[PhoneNumberValidationRegEx] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PhoneNumberValidationRegEx] end,
		[PhoneNumberDisplayFormat] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PhoneNumberDisplayFormat] end,
		[PhoneCountryCode] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [PhoneCountryCode] end
	where [CountryID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CountryID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpCountry]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
