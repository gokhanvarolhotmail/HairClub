create procedure [sp_MSupd_bi_mktg_ddsDimActivity]
		@c1 int = NULL,
		@c2 nvarchar(10) = NULL,
		@c3 date = NULL,
		@c4 time = NULL,
		@c5 date = NULL,
		@c6 time = NULL,
		@c7 nvarchar(10) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(10) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(30) = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 nvarchar(10) = NULL,
		@c14 nvarchar(10) = NULL,
		@c15 nvarchar(10) = NULL,
		@c16 nvarchar(50) = NULL,
		@c17 nvarchar(10) = NULL,
		@c18 nvarchar(50) = NULL,
		@c19 nvarchar(10) = NULL,
		@c20 nvarchar(50) = NULL,
		@c21 float = NULL,
		@c22 nvarchar(50) = NULL,
		@c23 nvarchar(50) = NULL,
		@c24 int = NULL,
		@c25 int = NULL,
		@c26 int = NULL,
		@c27 int = NULL,
		@c28 int = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 tinyint = NULL,
		@c32 datetime = NULL,
		@c33 datetime = NULL,
		@c34 varchar(200) = NULL,
		@c35 tinyint = NULL,
		@c36 int = NULL,
		@c37 int = NULL,
		@c38 nvarchar(18) = NULL,
		@c39 nvarchar(18) = NULL,
		@c40 nvarchar(18) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimActivity] set
		[ActivitySSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActivitySSID] end,
		[ActivityDueDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ActivityDueDate] end,
		[ActivityStartTime] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivityStartTime] end,
		[ActivityCompletionDate] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActivityCompletionDate] end,
		[ActivityCompletionTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityCompletionTime] end,
		[ActionCodeSSID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ActionCodeSSID] end,
		[ActionCodeDescription] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ActionCodeDescription] end,
		[ResultCodeSSID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ResultCodeSSID] end,
		[ResultCodeDescription] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ResultCodeDescription] end,
		[SourceSSID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [SourceSSID] end,
		[SourceDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [SourceDescription] end,
		[CenterSSID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CenterSSID] end,
		[ContactSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ContactSSID] end,
		[SalesTypeSSID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [SalesTypeSSID] end,
		[SalesTypeDescription] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [SalesTypeDescription] end,
		[ActivityTypeSSID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ActivityTypeSSID] end,
		[ActivityTypeDescription] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ActivityTypeDescription] end,
		[TimeZoneSSID] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [TimeZoneSSID] end,
		[TimeZoneDescription] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [TimeZoneDescription] end,
		[GreenwichOffset] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [GreenwichOffset] end,
		[PromotionCodeSSID] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PromotionCodeSSID] end,
		[PromotionCodeDescription] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [PromotionCodeDescription] end,
		[IsAppointment] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [IsAppointment] end,
		[IsShow] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [IsShow] end,
		[IsNoShow] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [IsNoShow] end,
		[IsSale] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [IsSale] end,
		[IsNoSale] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsNoSale] end,
		[IsConsultation] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [IsConsultation] end,
		[IsBeBack] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [IsBeBack] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [UpdateAuditKey] end,
		[SFDC_TaskID] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [SFDC_TaskID] end,
		[SFDC_LeadID] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [SFDC_LeadID] end,
		[SFDC_PersonAccountID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [SFDC_PersonAccountID] end
	where [ActivityKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimActivity]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
