/* CreateDate: 09/03/2021 09:37:07.727 , ModifyDate: 09/03/2021 09:37:07.727 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_mktg_ddsFactLeadMonthly]
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
		@c27 int = NULL,
		@c28 int = NULL,
		@c29 int = NULL,
		@c30 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [bi_mktg_dds].[FactLeadMonthly] set
		[ContactKey] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ContactKey] end,
		[LeadCreationDateKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [LeadCreationDateKey] end,
		[LeadCreationTimeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LeadCreationTimeKey] end,
		[CenterKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterKey] end,
		[SourceKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SourceKey] end,
		[GenderKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [GenderKey] end,
		[OccupationKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [OccupationKey] end,
		[EthnicityKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EthnicityKey] end,
		[MaritalStatusKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MaritalStatusKey] end,
		[HairLossTypeKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HairLossTypeKey] end,
		[AgeRangeKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AgeRangeKey] end,
		[EmployeeKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [EmployeeKey] end,
		[PromotionCodeKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PromotionCodeKey] end,
		[SalesTypeKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [SalesTypeKey] end,
		[Leads] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Leads] end,
		[Appointments] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Appointments] end,
		[Shows] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Shows] end,
		[Sales] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Sales] end,
		[Activities] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Activities] end,
		[NoShows] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NoShows] end,
		[NoSales] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [NoSales] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [UpdateAuditKey] end,
		[AssignedEmployeeKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [AssignedEmployeeKey] end,
		[SHOWDIFF] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SHOWDIFF] end,
		[SALEDIFF] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [SALEDIFF] end,
		[QuestionAge] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [QuestionAge] end,
		[RecentSourceKey] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RecentSourceKey] end,
		[InvalidLead] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [InvalidLead] end,
		[MonthlyInsertDate] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [MonthlyInsertDate] end
	where [ContactKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ContactKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactLeadMonthly]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [bi_mktg_dds].[FactLeadMonthly] set
		[LeadCreationDateKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [LeadCreationDateKey] end,
		[LeadCreationTimeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LeadCreationTimeKey] end,
		[CenterKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterKey] end,
		[SourceKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SourceKey] end,
		[GenderKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [GenderKey] end,
		[OccupationKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [OccupationKey] end,
		[EthnicityKey] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EthnicityKey] end,
		[MaritalStatusKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [MaritalStatusKey] end,
		[HairLossTypeKey] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [HairLossTypeKey] end,
		[AgeRangeKey] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AgeRangeKey] end,
		[EmployeeKey] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [EmployeeKey] end,
		[PromotionCodeKey] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PromotionCodeKey] end,
		[SalesTypeKey] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [SalesTypeKey] end,
		[Leads] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Leads] end,
		[Appointments] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [Appointments] end,
		[Shows] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Shows] end,
		[Sales] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [Sales] end,
		[Activities] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [Activities] end,
		[NoShows] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [NoShows] end,
		[NoSales] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [NoSales] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [UpdateAuditKey] end,
		[AssignedEmployeeKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [AssignedEmployeeKey] end,
		[SHOWDIFF] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [SHOWDIFF] end,
		[SALEDIFF] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [SALEDIFF] end,
		[QuestionAge] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [QuestionAge] end,
		[RecentSourceKey] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RecentSourceKey] end,
		[InvalidLead] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [InvalidLead] end,
		[MonthlyInsertDate] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [MonthlyInsertDate] end
	where [ContactKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ContactKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactLeadMonthly]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
