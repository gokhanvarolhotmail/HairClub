/* CreateDate: 09/03/2021 09:37:07.607 , ModifyDate: 09/03/2021 09:37:07.607 */
GO
create procedure [sp_MSins_bi_mktg_ddsFactActivityResultsMonthly]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 int,
    @c10 int,
    @c11 int,
    @c12 int,
    @c13 int,
    @c14 int,
    @c15 int,
    @c16 int,
    @c17 int,
    @c18 int,
    @c19 int,
    @c20 int,
    @c21 int,
    @c22 int,
    @c23 int,
    @c24 int,
    @c25 int,
    @c26 int,
    @c27 nvarchar(50),
    @c28 int,
    @c29 int,
    @c30 int,
    @c31 int,
    @c32 int,
    @c33 int,
    @c34 int,
    @c35 int,
    @c36 int,
    @c37 money,
    @c38 int,
    @c39 int,
    @c40 int,
    @c41 nvarchar(80),
    @c42 int,
    @c43 int,
    @c44 int,
    @c45 int,
    @c46 datetime
as
begin
	insert into [bi_mktg_dds].[FactActivityResultsMonthly] (
		[ActivityKey],
		[ActivityDateKey],
		[ActivityTimeKey],
		[ActivityResultDateKey],
		[ActivityResultKey],
		[ActivityResultTimeKey],
		[ActivityCompletedDateKey],
		[ActivityCompletedTimeKey],
		[ActivityDueDateKey],
		[ActivityStartTimeKey],
		[OriginalAppointmentDateKey],
		[ActivitySavedDateKey],
		[ActivitySavedTimeKey],
		[ContactKey],
		[CenterKey],
		[SalesTypeKey],
		[SourceKey],
		[ActionCodeKey],
		[ResultCodeKey],
		[GenderKey],
		[OccupationKey],
		[EthnicityKey],
		[MaritalStatusKey],
		[HairLossTypeKey],
		[AgeRangeKey],
		[CompletedByEmployeeKey],
		[ClientNumber],
		[Appointments],
		[Show],
		[NoShow],
		[Sale],
		[NoSale],
		[Consultation],
		[BeBack],
		[SurgeryOffered],
		[ReferredToDoctor],
		[InitialPayment],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[ActivityEmployeeKey],
		[Accomodation],
		[LeadSourceKey],
		[LeadCreationDateKey],
		[LeadCreationTimeKey],
		[PromoCodeKey],
		[MonthlyInsertDate]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		default,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46	)
end
GO
