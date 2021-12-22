/* CreateDate: 01/08/2021 15:21:53.567 , ModifyDate: 01/08/2021 15:21:53.567 */
GO
create procedure [sp_MSupd_bi_ent_ddsDimCenterOwnership]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(10) = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 nvarchar(10) = NULL,
		@c14 nvarchar(50) = NULL,
		@c15 nvarchar(15) = NULL,
		@c16 tinyint = NULL,
		@c17 datetime = NULL,
		@c18 datetime = NULL,
		@c19 varchar(200) = NULL,
		@c20 tinyint = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_ent_dds].[DimCenterOwnership] set
		[CenterOwnershipSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterOwnershipSSID] end,
		[CenterOwnershipDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterOwnershipDescription] end,
		[CenterOwnershipDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterOwnershipDescriptionShort] end,
		[OwnerLastName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [OwnerLastName] end,
		[OwnerFirstName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [OwnerFirstName] end,
		[CorporateName] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CorporateName] end,
		[CenterAddress1] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CenterAddress1] end,
		[CenterAddress2] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CenterAddress2] end,
		[CountryRegionDescription] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CountryRegionDescription] end,
		[CountryRegionDescriptionShort] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CountryRegionDescriptionShort] end,
		[StateProvinceDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [StateProvinceDescription] end,
		[StateProvinceDescriptionShort] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [StateProvinceDescriptionShort] end,
		[City] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [City] end,
		[PostalCode] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PostalCode] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [msrepl_tran_version] end
	where [CenterOwnershipKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterOwnershipKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimCenterOwnership]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
