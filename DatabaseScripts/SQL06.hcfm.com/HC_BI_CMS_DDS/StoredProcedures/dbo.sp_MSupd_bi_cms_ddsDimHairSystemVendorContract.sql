/* CreateDate: 10/03/2019 23:03:41.243 , ModifyDate: 10/03/2019 23:03:41.243 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimHairSystemVendorContract]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(10) = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 nchar(1) = NULL,
		@c9 nchar(1) = NULL,
		@c10 tinyint = NULL,
		@c11 datetime = NULL,
		@c12 datetime = NULL,
		@c13 varchar(200) = NULL,
		@c14 tinyint = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimHairSystemVendorContract] set
		[HairSystemVendorContractSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [HairSystemVendorContractSSID] end,
		[HairSystemVendorContractName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HairSystemVendorContractName] end,
		[HairSystemVendorDescription] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [HairSystemVendorDescription] end,
		[HairSystemVendorDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HairSystemVendorDescriptionShort] end,
		[HairSystemVendorContractBeginDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [HairSystemVendorContractBeginDate] end,
		[HairSystemVendorContractEndDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [HairSystemVendorContractEndDate] end,
		[IsRepair] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsRepair] end,
		[IsActiveContract] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveContract] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [msrepl_tran_version] end
	where [HairSystemVendorContractKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemVendorContractKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimHairSystemVendorContract]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
