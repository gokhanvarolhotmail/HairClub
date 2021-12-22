/* CreateDate: 09/03/2021 09:37:07.180 , ModifyDate: 09/03/2021 09:37:07.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_MSupd_bi_mktg_ddsFactCallData]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_mktg_dds].[FactCallData] set
		[CallRecordKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CallRecordKey] end,
		[CallDateKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CallDateKey] end,
		[CallTimeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CallTimeKey] end,
		[InboundSourceKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InboundSourceKey] end,
		[ContactKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ContactKey] end,
		[ActivityKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityKey] end,
		[IsViableCall] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsViableCall] end,
		[CallLength] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CallLength] end,
		[RowTimeStamp] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowTimeStamp] end
	where [CallRecordKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CallRecordKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactCallData]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[FactCallData] set
		[CallDateKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CallDateKey] end,
		[CallTimeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CallTimeKey] end,
		[InboundSourceKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [InboundSourceKey] end,
		[ContactKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ContactKey] end,
		[ActivityKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityKey] end,
		[IsViableCall] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsViableCall] end,
		[CallLength] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CallLength] end,
		[RowTimeStamp] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [RowTimeStamp] end
	where [CallRecordKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CallRecordKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactCallData]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
