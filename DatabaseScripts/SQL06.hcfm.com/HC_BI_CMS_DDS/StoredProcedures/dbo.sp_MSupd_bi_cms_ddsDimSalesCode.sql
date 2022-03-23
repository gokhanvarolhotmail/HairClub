/* CreateDate: 03/17/2022 11:57:06.570 , ModifyDate: 03/17/2022 11:57:06.570 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimSalesCode]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(15) = NULL,
		@c5 int = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(10) = NULL,
		@c8 int = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(10) = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 money = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 tinyint = NULL,
		@c18 datetime = NULL,
		@c19 datetime = NULL,
		@c20 varchar(200) = NULL,
		@c21 tinyint = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 uniqueidentifier = NULL,
		@c25 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimSalesCode] set
		[SalesCodeSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SalesCodeSSID] end,
		[SalesCodeDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalesCodeDescription] end,
		[SalesCodeDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SalesCodeDescriptionShort] end,
		[SalesCodeTypeSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalesCodeTypeSSID] end,
		[SalesCodeTypeDescription] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesCodeTypeDescription] end,
		[SalesCodeTypeDescriptionShort] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SalesCodeTypeDescriptionShort] end,
		[ProductVendorSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ProductVendorSSID] end,
		[ProductVendorDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ProductVendorDescription] end,
		[ProductVendorDescriptionShort] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ProductVendorDescriptionShort] end,
		[SalesCodeDepartmentKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [SalesCodeDepartmentKey] end,
		[SalesCodeDepartmentSSID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [SalesCodeDepartmentSSID] end,
		[Barcode] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Barcode] end,
		[PriceDefault] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [PriceDefault] end,
		[GLNumber] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [GLNumber] end,
		[ServiceDuration] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ServiceDuration] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [msrepl_tran_version] end,
		[SalesCodeSortOrder] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SalesCodeSortOrder] end
	where [SalesCodeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SalesCodeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimSalesCode]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
