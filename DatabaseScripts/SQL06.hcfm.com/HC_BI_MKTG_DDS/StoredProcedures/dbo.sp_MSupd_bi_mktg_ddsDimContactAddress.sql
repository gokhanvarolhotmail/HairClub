/* CreateDate: 09/03/2021 09:37:05.597 , ModifyDate: 09/03/2021 09:37:05.597 */
GO
create procedure [sp_MSupd_bi_mktg_ddsDimContactAddress]
		@c1 int = NULL,
		@c2 nvarchar(10) = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 nvarchar(255) = NULL,
		@c6 nvarchar(250) = NULL,
		@c7 nvarchar(250) = NULL,
		@c8 nvarchar(250) = NULL,
		@c9 nvarchar(20) = NULL,
		@c10 nvarchar(20) = NULL,
		@c11 nvarchar(60) = NULL,
		@c12 nvarchar(20) = NULL,
		@c13 nvarchar(50) = NULL,
		@c14 nvarchar(50) = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 nvarchar(10) = NULL,
		@c17 nvarchar(50) = NULL,
		@c18 nvarchar(20) = NULL,
		@c19 nvarchar(100) = NULL,
		@c20 nvarchar(10) = NULL,
		@c21 nvarchar(10) = NULL,
		@c22 nchar(1) = NULL,
		@c23 tinyint = NULL,
		@c24 datetime = NULL,
		@c25 datetime = NULL,
		@c26 varchar(200) = NULL,
		@c27 tinyint = NULL,
		@c28 int = NULL,
		@c29 int = NULL,
		@c30 nvarchar(18) = NULL,
		@c31 nvarchar(18) = NULL,
		@c32 nvarchar(18) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimContactAddress] set
		[ContactAddressSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ContactAddressSSID] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ContactSSID] end,
		[AddressTypeCode] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AddressTypeCode] end,
		[AddressLine1] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AddressLine1] end,
		[AddressLine2] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AddressLine2] end,
		[AddressLine3] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AddressLine3] end,
		[AddressLine4] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [AddressLine4] end,
		[AddressLine1Soundex] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [AddressLine1Soundex] end,
		[AddressLine2Soundex] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AddressLine2Soundex] end,
		[City] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [City] end,
		[CitySoundex] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CitySoundex] end,
		[StateCode] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [StateCode] end,
		[StateName] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [StateName] end,
		[ZipCode] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ZipCode] end,
		[CountyCode] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [CountyCode] end,
		[CountyName] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CountyName] end,
		[CountryCode] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CountryCode] end,
		[CountryName] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CountryName] end,
		[CountryPrefix] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CountryPrefix] end,
		[TimeZoneCode] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [TimeZoneCode] end,
		[PrimaryFlag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PrimaryFlag] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [UpdateAuditKey] end,
		[SFDC_LeadID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [SFDC_LeadID] end,
		[SFDC_LeadAddressID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [SFDC_LeadAddressID] end,
		[SFDC_PersonAccountID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [SFDC_PersonAccountID] end
	where [ContactAddressKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ContactAddressKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimContactAddress]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
