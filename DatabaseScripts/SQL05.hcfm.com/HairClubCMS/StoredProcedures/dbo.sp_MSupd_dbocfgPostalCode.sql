/* CreateDate: 05/05/2020 17:42:44.653 , ModifyDate: 05/05/2020 17:42:44.653 */
GO
create procedure [sp_MSupd_dbocfgPostalCode]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 nvarchar(10) = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cfgPostalCode] set
		[zip_code] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [zip_code] end,
		[city] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [city] end,
		[country_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [country_code] end,
		[state_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [state_code] end,
		[county_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [county_code] end,
		[facility_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [facility_code] end,
		[StateID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [StateID] end,
		[CountryID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CountryID] end
	where [zip_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[zip_code] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgPostalCode]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[cfgPostalCode] set
		[city] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [city] end,
		[country_code] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [country_code] end,
		[state_code] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [state_code] end,
		[county_code] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [county_code] end,
		[facility_code] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [facility_code] end,
		[StateID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [StateID] end,
		[CountryID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CountryID] end
	where [zip_code] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[zip_code] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgPostalCode]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
