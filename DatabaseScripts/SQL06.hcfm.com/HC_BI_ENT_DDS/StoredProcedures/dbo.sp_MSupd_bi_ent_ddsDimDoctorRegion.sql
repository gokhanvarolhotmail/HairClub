/* CreateDate: 01/08/2021 15:21:53.697 , ModifyDate: 01/08/2021 15:21:53.697 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_ent_ddsDimDoctorRegion]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 tinyint = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 varchar(200) = NULL,
		@c9 tinyint = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 uniqueidentifier = NULL,
		@c13 nchar(1) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_ent_dds].[DimDoctorRegion] set
		[DoctorRegionSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [DoctorRegionSSID] end,
		[DoctorRegionDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [DoctorRegionDescription] end,
		[DoctorRegionDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [DoctorRegionDescriptionShort] end,
		[RowIsCurrent] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [msrepl_tran_version] end,
		[Active] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Active] end
	where [DoctorRegionKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DoctorRegionKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_ent_dds].[DimDoctorRegion]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
