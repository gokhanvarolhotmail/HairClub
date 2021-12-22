create procedure [sp_MSins_dbodatIncomingRequestLog]
    @c1 int,
    @c2 nvarchar(20),
    @c3 nvarchar(50),
    @c4 int,
    @c5 nvarchar(50),
    @c6 int,
    @c7 nvarchar(50),
    @c8 datetime,
    @c9 nvarchar(50),
    @c10 int,
    @c11 decimal(14,4),
    @c12 nvarchar(30),
    @c13 datetime,
    @c14 int,
    @c15 decimal(14,4),
    @c16 datetime,
    @c17 decimal(14,4),
    @c18 nvarchar(30),
    @c19 bit,
    @c20 nvarchar(4000),
    @c21 datetime,
    @c22 nvarchar(25),
    @c23 datetime,
    @c24 nvarchar(25),
    @c25 nvarchar(50),
    @c26 nvarchar(50),
    @c27 datetime
as
begin
	insert into [dbo].[datIncomingRequestLog](
		[IncomingRequestID],
		[ProcessName],
		[SiebelID],
		[ConectID],
		[ClientMembershipID],
		[BosleyRequestID],
		[PatientSlipNo],
		[TreatmentPlanDate],
		[TreatmentPlanNo],
		[TreatmentPlanGraftCount],
		[TreatmentPlanContractAmount],
		[ProcedureStatus],
		[ProcedureDate],
		[ProcedureGraftCount],
		[ProcedureAmount],
		[PaymentDate],
		[PaymentAmount],
		[PaymentType],
		[IsProcessedFlag],
		[ErrorMessage],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ConsultantUserName],
		[ConsultationStatus],
		[ConsultationStatusDate]
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
    default,
    @c25,
    @c26,
    @c27	)
end
