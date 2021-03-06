/* CreateDate: 09/03/2021 09:37:05.327 , ModifyDate: 09/03/2021 09:37:05.327 */
GO
create procedure [sp_MSins_bi_mktg_ddsDimActivityResult]
    @c1 int,
    @c2 varchar(10),
    @c3 nvarchar(10),
    @c4 varchar(10),
    @c5 varchar(10),
    @c6 nvarchar(10),
    @c7 nvarchar(50),
    @c8 nvarchar(10),
    @c9 nvarchar(50),
    @c10 nvarchar(10),
    @c11 nvarchar(50),
    @c12 nvarchar(30),
    @c13 nvarchar(50),
    @c14 nchar(1),
    @c15 nchar(1),
    @c16 nvarchar(10),
    @c17 decimal(15,4),
    @c18 nvarchar(50),
    @c19 decimal(15,4),
    @c20 int,
    @c21 date,
    @c22 date,
    @c23 nchar(1),
    @c24 date,
    @c25 nchar(1),
    @c26 nchar(1),
    @c27 tinyint,
    @c28 datetime,
    @c29 datetime,
    @c30 varchar(200),
    @c31 tinyint,
    @c32 int,
    @c33 int,
    @c34 nvarchar(18),
    @c35 nvarchar(18),
    @c36 nvarchar(80),
    @c37 nvarchar(18)
as
begin
	insert into [bi_mktg_dds].[DimActivityResult] (
		[ActivityResultKey],
		[ActivityResultSSID],
		[CenterSSID],
		[ActivitySSID],
		[ContactSSID],
		[SalesTypeSSID],
		[SalesTypeDescription],
		[ActionCodeSSID],
		[ActionCodeDescription],
		[ResultCodeSSID],
		[ResultCodeDescription],
		[SourceSSID],
		[SourceDescription],
		[IsShow],
		[IsSale],
		[ContractNumber],
		[ContractAmount],
		[ClientNumber],
		[InitialPayment],
		[NumberOfGraphs],
		[OrigApptDate],
		[DateSaved],
		[RescheduledFlag],
		[RescheduledDate],
		[SurgeryOffered],
		[ReferredToDoctor],
		[RowIsCurrent],
		[RowStartDate],
		[RowEndDate],
		[RowChangeReason],
		[RowIsInferred],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[SFDC_TaskID],
		[SFDC_LeadID],
		[Accomodation],
		[SFDC_PersonAccountID]
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
		default,
		@c34,
		@c35,
		@c36,
		@c37	)
end
GO
