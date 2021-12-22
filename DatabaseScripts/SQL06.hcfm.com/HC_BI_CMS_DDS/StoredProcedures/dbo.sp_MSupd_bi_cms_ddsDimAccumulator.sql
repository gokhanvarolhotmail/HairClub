/* CreateDate: 10/03/2019 23:03:39.750 , ModifyDate: 10/03/2019 23:03:39.750 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_cms_ddsDimAccumulator]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(10) = NULL,
		@c8 int = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(10) = NULL,
		@c11 int = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 nvarchar(10) = NULL,
		@c14 tinyint = NULL,
		@c15 datetime = NULL,
		@c16 datetime = NULL,
		@c17 varchar(200) = NULL,
		@c18 tinyint = NULL,
		@c19 int = NULL,
		@c20 int = NULL,
		@c21 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimAccumulator] set
		[AccumulatorSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AccumulatorSSID] end,
		[AccumulatorDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [AccumulatorDescription] end,
		[AccumulatorDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AccumulatorDescriptionShort] end,
		[AccumulatorDataTypeSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [AccumulatorDataTypeSSID] end,
		[AccumulatorDataTypeDescription] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [AccumulatorDataTypeDescription] end,
		[AccumulatorDataTypeDescriptionShort] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [AccumulatorDataTypeDescriptionShort] end,
		[SchedulerActionTypeSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [SchedulerActionTypeSSID] end,
		[SchedulerActionTypeDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SchedulerActionTypeDescription] end,
		[SchedulerActionTypeDescriptionShort] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [SchedulerActionTypeDescriptionShort] end,
		[SchedulerAdjustmentTypeSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [SchedulerAdjustmentTypeSSID] end,
		[SchedulerAdjustmentTypeDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [SchedulerAdjustmentTypeDescription] end,
		[SchedulerAdjustmentTypeDescriptionShort] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [SchedulerAdjustmentTypeDescriptionShort] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [msrepl_tran_version] end
	where [AccumulatorKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AccumulatorKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimAccumulator]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
