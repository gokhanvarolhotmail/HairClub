/* CreateDate: 09/03/2021 09:37:07.633 , ModifyDate: 09/03/2021 09:37:07.633 */
GO
create procedure [sp_MSupd_bi_mktg_ddsFactActivityResultsMonthly]
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
		@c25 int = NULL,
		@c26 int = NULL,
		@c27 nvarchar(50) = NULL,
		@c28 int = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 int = NULL,
		@c32 int = NULL,
		@c33 int = NULL,
		@c34 int = NULL,
		@c35 int = NULL,
		@c36 int = NULL,
		@c37 money = NULL,
		@c38 int = NULL,
		@c39 int = NULL,
		@c40 int = NULL,
		@c41 nvarchar(80) = NULL,
		@c42 int = NULL,
		@c43 int = NULL,
		@c44 int = NULL,
		@c45 int = NULL,
		@c46 datetime = NULL,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@pkc3 int = NULL,
		@bitmap binary(6)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 4 = 4)
begin
update [bi_mktg_dds].[FactActivityResultsMonthly] set
		[ActivityKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ActivityKey] end,
		[ActivityDateKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ActivityDateKey] end,
		[ActivityTimeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ActivityTimeKey] end,
		[ActivityResultDateKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivityResultDateKey] end,
		[ActivityResultKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActivityResultKey] end,
		[ActivityResultTimeKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityResultTimeKey] end,
		[ActivityCompletedDateKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ActivityCompletedDateKey] end,
		[ActivityCompletedTimeKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ActivityCompletedTimeKey] end,
		[ActivityDueDateKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ActivityDueDateKey] end,
		[ActivityStartTimeKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ActivityStartTimeKey] end,
		[OriginalAppointmentDateKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [OriginalAppointmentDateKey] end,
		[ActivitySavedDateKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ActivitySavedDateKey] end,
		[ActivitySavedTimeKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ActivitySavedTimeKey] end,
		[ContactKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ContactKey] end,
		[CenterKey] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CenterKey] end,
		[SalesTypeKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [SalesTypeKey] end,
		[SourceKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [SourceKey] end,
		[ActionCodeKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ActionCodeKey] end,
		[ResultCodeKey] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ResultCodeKey] end,
		[GenderKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [GenderKey] end,
		[OccupationKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OccupationKey] end,
		[EthnicityKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [EthnicityKey] end,
		[MaritalStatusKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MaritalStatusKey] end,
		[HairLossTypeKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [HairLossTypeKey] end,
		[AgeRangeKey] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [AgeRangeKey] end,
		[CompletedByEmployeeKey] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [CompletedByEmployeeKey] end,
		[ClientNumber] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [ClientNumber] end,
		[Appointments] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [Appointments] end,
		[Show] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Show] end,
		[NoShow] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [NoShow] end,
		[Sale] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Sale] end,
		[NoSale] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [NoSale] end,
		[Consultation] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Consultation] end,
		[BeBack] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [BeBack] end,
		[SurgeryOffered] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SurgeryOffered] end,
		[ReferredToDoctor] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [ReferredToDoctor] end,
		[InitialPayment] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [InitialPayment] end,
		[InsertAuditKey] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [UpdateAuditKey] end,
		[ActivityEmployeeKey] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [ActivityEmployeeKey] end,
		[Accomodation] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [Accomodation] end,
		[LeadSourceKey] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [LeadSourceKey] end,
		[LeadCreationDateKey] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [LeadCreationDateKey] end,
		[LeadCreationTimeKey] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [LeadCreationTimeKey] end,
		[PromoCodeKey] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [PromoCodeKey] end,
		[MonthlyInsertDate] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [MonthlyInsertDate] end
	where [ActivityKey] = @pkc1
  and [ActivityDateKey] = @pkc2
  and [ActivityTimeKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityDateKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityTimeKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactActivityResultsMonthly]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[FactActivityResultsMonthly] set
		[ActivityResultDateKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ActivityResultDateKey] end,
		[ActivityResultKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActivityResultKey] end,
		[ActivityResultTimeKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActivityResultTimeKey] end,
		[ActivityCompletedDateKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ActivityCompletedDateKey] end,
		[ActivityCompletedTimeKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ActivityCompletedTimeKey] end,
		[ActivityDueDateKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ActivityDueDateKey] end,
		[ActivityStartTimeKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ActivityStartTimeKey] end,
		[OriginalAppointmentDateKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [OriginalAppointmentDateKey] end,
		[ActivitySavedDateKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ActivitySavedDateKey] end,
		[ActivitySavedTimeKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ActivitySavedTimeKey] end,
		[ContactKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ContactKey] end,
		[CenterKey] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CenterKey] end,
		[SalesTypeKey] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [SalesTypeKey] end,
		[SourceKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [SourceKey] end,
		[ActionCodeKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [ActionCodeKey] end,
		[ResultCodeKey] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [ResultCodeKey] end,
		[GenderKey] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [GenderKey] end,
		[OccupationKey] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OccupationKey] end,
		[EthnicityKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [EthnicityKey] end,
		[MaritalStatusKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [MaritalStatusKey] end,
		[HairLossTypeKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [HairLossTypeKey] end,
		[AgeRangeKey] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [AgeRangeKey] end,
		[CompletedByEmployeeKey] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [CompletedByEmployeeKey] end,
		[ClientNumber] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [ClientNumber] end,
		[Appointments] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [Appointments] end,
		[Show] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Show] end,
		[NoShow] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [NoShow] end,
		[Sale] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Sale] end,
		[NoSale] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [NoSale] end,
		[Consultation] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Consultation] end,
		[BeBack] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [BeBack] end,
		[SurgeryOffered] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SurgeryOffered] end,
		[ReferredToDoctor] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [ReferredToDoctor] end,
		[InitialPayment] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [InitialPayment] end,
		[InsertAuditKey] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [UpdateAuditKey] end,
		[ActivityEmployeeKey] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [ActivityEmployeeKey] end,
		[Accomodation] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [Accomodation] end,
		[LeadSourceKey] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [LeadSourceKey] end,
		[LeadCreationDateKey] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [LeadCreationDateKey] end,
		[LeadCreationTimeKey] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [LeadCreationTimeKey] end,
		[PromoCodeKey] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [PromoCodeKey] end,
		[MonthlyInsertDate] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [MonthlyInsertDate] end
	where [ActivityKey] = @pkc1
  and [ActivityDateKey] = @pkc2
  and [ActivityTimeKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityDateKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityTimeKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactActivityResultsMonthly]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
