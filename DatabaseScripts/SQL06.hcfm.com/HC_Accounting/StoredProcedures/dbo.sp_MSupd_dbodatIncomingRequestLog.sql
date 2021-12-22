create procedure [sp_MSupd_dbodatIncomingRequestLog]
		@c1 int = NULL,
		@c2 nvarchar(20) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 int = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 int = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 int = NULL,
		@c11 decimal(14,4) = NULL,
		@c12 nvarchar(30) = NULL,
		@c13 datetime = NULL,
		@c14 int = NULL,
		@c15 decimal(14,4) = NULL,
		@c16 datetime = NULL,
		@c17 decimal(14,4) = NULL,
		@c18 nvarchar(30) = NULL,
		@c19 bit = NULL,
		@c20 nvarchar(4000) = NULL,
		@c21 datetime = NULL,
		@c22 nvarchar(25) = NULL,
		@c23 datetime = NULL,
		@c24 nvarchar(25) = NULL,
		@c25 nvarchar(50) = NULL,
		@c26 nvarchar(50) = NULL,
		@c27 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datIncomingRequestLog] set
		[IncomingRequestID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [IncomingRequestID] end,
		[ProcessName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ProcessName] end,
		[SiebelID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SiebelID] end,
		[ConectID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ConectID] end,
		[ClientMembershipID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientMembershipID] end,
		[BosleyRequestID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BosleyRequestID] end,
		[PatientSlipNo] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PatientSlipNo] end,
		[TreatmentPlanDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [TreatmentPlanDate] end,
		[TreatmentPlanNo] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TreatmentPlanNo] end,
		[TreatmentPlanGraftCount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [TreatmentPlanGraftCount] end,
		[TreatmentPlanContractAmount] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [TreatmentPlanContractAmount] end,
		[ProcedureStatus] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ProcedureStatus] end,
		[ProcedureDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ProcedureDate] end,
		[ProcedureGraftCount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ProcedureGraftCount] end,
		[ProcedureAmount] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ProcedureAmount] end,
		[PaymentDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PaymentDate] end,
		[PaymentAmount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PaymentAmount] end,
		[PaymentType] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [PaymentType] end,
		[IsProcessedFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsProcessedFlag] end,
		[ErrorMessage] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ErrorMessage] end,
		[CreateDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdateUser] end,
		[ConsultantUserName] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [ConsultantUserName] end,
		[ConsultationStatus] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ConsultationStatus] end,
		[ConsultationStatusDate] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [ConsultationStatusDate] end
where [IncomingRequestID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
else
begin
update [dbo].[datIncomingRequestLog] set
		[ProcessName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ProcessName] end,
		[SiebelID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SiebelID] end,
		[ConectID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ConectID] end,
		[ClientMembershipID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientMembershipID] end,
		[BosleyRequestID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [BosleyRequestID] end,
		[PatientSlipNo] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PatientSlipNo] end,
		[TreatmentPlanDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [TreatmentPlanDate] end,
		[TreatmentPlanNo] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [TreatmentPlanNo] end,
		[TreatmentPlanGraftCount] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [TreatmentPlanGraftCount] end,
		[TreatmentPlanContractAmount] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [TreatmentPlanContractAmount] end,
		[ProcedureStatus] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ProcedureStatus] end,
		[ProcedureDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ProcedureDate] end,
		[ProcedureGraftCount] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ProcedureGraftCount] end,
		[ProcedureAmount] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ProcedureAmount] end,
		[PaymentDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PaymentDate] end,
		[PaymentAmount] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PaymentAmount] end,
		[PaymentType] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [PaymentType] end,
		[IsProcessedFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsProcessedFlag] end,
		[ErrorMessage] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [ErrorMessage] end,
		[CreateDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [LastUpdateUser] end,
		[ConsultantUserName] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [ConsultantUserName] end,
		[ConsultationStatus] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ConsultationStatus] end,
		[ConsultationStatusDate] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [ConsultationStatusDate] end
where [IncomingRequestID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
        exec sp_MSreplraiserror 20598
end
end
