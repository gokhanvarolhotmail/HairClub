create procedure [sp_MSupd_bi_mktg_ddsDimActivityResultMonthly]
		@c1 int = NULL,
		@c2 varchar(10) = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 varchar(10) = NULL,
		@c5 varchar(10) = NULL,
		@c6 nvarchar(10) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(10) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(10) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(30) = NULL,
		@c13 nvarchar(50) = NULL,
		@c14 nchar(1) = NULL,
		@c15 nchar(1) = NULL,
		@c16 nvarchar(10) = NULL,
		@c17 decimal(15,4) = NULL,
		@c18 nvarchar(50) = NULL,
		@c19 decimal(15,4) = NULL,
		@c20 int = NULL,
		@c21 date = NULL,
		@c22 date = NULL,
		@c23 nchar(1) = NULL,
		@c24 date = NULL,
		@c25 nchar(1) = NULL,
		@c26 nchar(1) = NULL,
		@c27 tinyint = NULL,
		@c28 datetime = NULL,
		@c29 datetime = NULL,
		@c30 varchar(200) = NULL,
		@c31 tinyint = NULL,
		@c32 int = NULL,
		@c33 int = NULL,
		@c34 nvarchar(18) = NULL,
		@c35 nvarchar(18) = NULL,
		@c36 nvarchar(80) = NULL,
		@c37 nvarchar(18) = NULL,
		@c38 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_mktg_dds].[DimActivityResultMonthly] set
		[ActivityResultKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ActivityResultKey] end,
		[ActivityResultSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActivityResultSSID] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterSSID] end,
		[ActivitySSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivitySSID] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ContactSSID] end,
		[SalesTypeSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesTypeSSID] end,
		[SalesTypeDescription] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SalesTypeDescription] end,
		[ActionCodeSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ActionCodeSSID] end,
		[ActionCodeDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ActionCodeDescription] end,
		[ResultCodeSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ResultCodeSSID] end,
		[ResultCodeDescription] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ResultCodeDescription] end,
		[SourceSSID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [SourceSSID] end,
		[SourceDescription] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [SourceDescription] end,
		[IsShow] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsShow] end,
		[IsSale] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsSale] end,
		[ContractNumber] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ContractNumber] end,
		[ContractAmount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ContractAmount] end,
		[ClientNumber] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ClientNumber] end,
		[InitialPayment] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [InitialPayment] end,
		[NumberOfGraphs] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NumberOfGraphs] end,
		[OrigApptDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OrigApptDate] end,
		[DateSaved] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [DateSaved] end,
		[RescheduledFlag] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [RescheduledFlag] end,
		[RescheduledDate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [RescheduledDate] end,
		[SurgeryOffered] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SurgeryOffered] end,
		[ReferredToDoctor] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ReferredToDoctor] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [UpdateAuditKey] end,
		[SFDC_TaskID] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [SFDC_TaskID] end,
		[SFDC_LeadID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SFDC_LeadID] end,
		[Accomodation] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Accomodation] end,
		[SFDC_PersonAccountID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [SFDC_PersonAccountID] end,
		[MonthlyInsertDate] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [MonthlyInsertDate] end
	where [ActivityResultKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityResultKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimActivityResultMonthly]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[DimActivityResultMonthly] set
		[ActivityResultSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActivityResultSSID] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterSSID] end,
		[ActivitySSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivitySSID] end,
		[ContactSSID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ContactSSID] end,
		[SalesTypeSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalesTypeSSID] end,
		[SalesTypeDescription] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [SalesTypeDescription] end,
		[ActionCodeSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ActionCodeSSID] end,
		[ActionCodeDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ActionCodeDescription] end,
		[ResultCodeSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ResultCodeSSID] end,
		[ResultCodeDescription] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ResultCodeDescription] end,
		[SourceSSID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [SourceSSID] end,
		[SourceDescription] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [SourceDescription] end,
		[IsShow] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [IsShow] end,
		[IsSale] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsSale] end,
		[ContractNumber] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ContractNumber] end,
		[ContractAmount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ContractAmount] end,
		[ClientNumber] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ClientNumber] end,
		[InitialPayment] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [InitialPayment] end,
		[NumberOfGraphs] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NumberOfGraphs] end,
		[OrigApptDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OrigApptDate] end,
		[DateSaved] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [DateSaved] end,
		[RescheduledFlag] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [RescheduledFlag] end,
		[RescheduledDate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [RescheduledDate] end,
		[SurgeryOffered] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SurgeryOffered] end,
		[ReferredToDoctor] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ReferredToDoctor] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [UpdateAuditKey] end,
		[SFDC_TaskID] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [SFDC_TaskID] end,
		[SFDC_LeadID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SFDC_LeadID] end,
		[Accomodation] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [Accomodation] end,
		[SFDC_PersonAccountID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [SFDC_PersonAccountID] end,
		[MonthlyInsertDate] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [MonthlyInsertDate] end
	where [ActivityResultKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityResultKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimActivityResultMonthly]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
