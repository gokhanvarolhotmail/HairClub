/* CreateDate: 09/03/2021 09:37:06.757 , ModifyDate: 09/03/2021 09:37:06.757 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_mktg_ddsFactActivity]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 int = NULL,
		@c12 int = NULL,
		@c13 int = NULL,
		@c14 int = NULL,
		@c15 int = NULL,
		@c16 int = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 int = NULL,
		@c22 int = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@pkc3 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 4 = 4)
begin
update [bi_mktg_dds].[FactActivity] set
		[ActivityDateKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ActivityDateKey] end,
		[ActivityKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActivityKey] end,
		[ActivityTimeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ActivityTimeKey] end,
		[ActivityCompletedDateKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivityCompletedDateKey] end,
		[ActivityCompletedTimeKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActivityCompletedTimeKey] end,
		[ActivityDueDateKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityDueDateKey] end,
		[ActivityStartTimeKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ActivityStartTimeKey] end,
		[GenderKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [GenderKey] end,
		[EthnicityKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EthnicityKey] end,
		[OccupationKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [OccupationKey] end,
		[MaritalStatusKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MaritalStatusKey] end,
		[AgeRangeKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AgeRangeKey] end,
		[HairLossTypeKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [HairLossTypeKey] end,
		[CenterKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CenterKey] end,
		[ContactKey] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ContactKey] end,
		[ActionCodeKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ActionCodeKey] end,
		[ResultCodeKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ResultCodeKey] end,
		[SourceKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SourceKey] end,
		[ActivityTypeKey] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ActivityTypeKey] end,
		[CompletedByEmployeeKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CompletedByEmployeeKey] end,
		[StartedByEmployeeKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [StartedByEmployeeKey] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [UpdateAuditKey] end,
		[ActivityEmployeeKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [ActivityEmployeeKey] end
	where [ActivityDateKey] = @pkc1
  and [ActivityKey] = @pkc2
  and [ActivityTimeKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityDateKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityTimeKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactActivity]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[FactActivity] set
		[ActivityCompletedDateKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivityCompletedDateKey] end,
		[ActivityCompletedTimeKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActivityCompletedTimeKey] end,
		[ActivityDueDateKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityDueDateKey] end,
		[ActivityStartTimeKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ActivityStartTimeKey] end,
		[GenderKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [GenderKey] end,
		[EthnicityKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EthnicityKey] end,
		[OccupationKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [OccupationKey] end,
		[MaritalStatusKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [MaritalStatusKey] end,
		[AgeRangeKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [AgeRangeKey] end,
		[HairLossTypeKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [HairLossTypeKey] end,
		[CenterKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CenterKey] end,
		[ContactKey] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ContactKey] end,
		[ActionCodeKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ActionCodeKey] end,
		[ResultCodeKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ResultCodeKey] end,
		[SourceKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [SourceKey] end,
		[ActivityTypeKey] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ActivityTypeKey] end,
		[CompletedByEmployeeKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CompletedByEmployeeKey] end,
		[StartedByEmployeeKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [StartedByEmployeeKey] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [UpdateAuditKey] end,
		[ActivityEmployeeKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [ActivityEmployeeKey] end
	where [ActivityDateKey] = @pkc1
  and [ActivityKey] = @pkc2
  and [ActivityTimeKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityDateKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityTimeKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactActivity]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
