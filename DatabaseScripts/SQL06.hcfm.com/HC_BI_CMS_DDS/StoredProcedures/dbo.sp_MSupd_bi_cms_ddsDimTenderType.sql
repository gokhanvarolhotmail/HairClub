/* CreateDate: 10/03/2019 23:03:42.077 , ModifyDate: 10/03/2019 23:03:42.077 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimTenderType]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 tinyint = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 varchar(200) = NULL,
		@c10 tinyint = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimTenderType] set
		[TenderTypeSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TenderTypeSSID] end,
		[TenderTypeDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TenderTypeDescription] end,
		[TenderTypeDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [TenderTypeDescriptionShort] end,
		[MaxOccurrences] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [MaxOccurrences] end,
		[RowIsCurrent] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [msrepl_tran_version] end
	where [TenderTypeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TenderTypeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimTenderType]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
