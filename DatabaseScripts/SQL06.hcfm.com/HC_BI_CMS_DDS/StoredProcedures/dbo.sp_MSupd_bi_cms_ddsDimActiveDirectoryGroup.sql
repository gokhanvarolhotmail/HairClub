create procedure [sp_MSupd_bi_cms_ddsDimActiveDirectoryGroup]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 tinyint = NULL,
		@c4 datetime = NULL,
		@c5 datetime = NULL,
		@c6 varchar(200) = NULL,
		@c7 tinyint = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimActiveDirectoryGroup] set
		[ActiveDirectoryGroupSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActiveDirectoryGroupSSID] end,
		[RowIsCurrent] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [msrepl_tran_version] end
	where [ActiveDirectoryGroupKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActiveDirectoryGroupKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimActiveDirectoryGroup]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
