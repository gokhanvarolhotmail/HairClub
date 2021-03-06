/* CreateDate: 01/08/2021 15:21:54.017 , ModifyDate: 01/08/2021 15:21:54.017 */
GO
create procedure [sp_MSupd_bi_ent_ddsDimRegion]
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
		@c14 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_ent_dds].[DimRegion] set
		[RegionSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [RegionSSID] end,
		[RegionDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RegionDescription] end,
		[RegionDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [RegionDescriptionShort] end,
		[RegionSortOrder] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [RegionSortOrder] end,
		[RowIsCurrent] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [msrepl_tran_version] end,
		[RegionNumber] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RegionNumber] end
	where [RegionKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[RegionKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimRegion]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
