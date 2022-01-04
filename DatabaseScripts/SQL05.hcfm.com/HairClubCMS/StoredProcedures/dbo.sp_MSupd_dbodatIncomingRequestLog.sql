/* CreateDate: 05/05/2020 17:42:47.453 , ModifyDate: 05/05/2020 17:42:47.453 */
GO
create procedure [sp_MSupd_dbodatIncomingRequestLog]
		@c1 int = NULL,
		@c2 nvarchar(25) = NULL,
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
		@c28 nvarchar(4000) = NULL,
		@c29 nvarchar(1) = NULL,
		@c30 nvarchar(50) = NULL,
		@c31 nvarchar(50) = NULL,
		@c32 nvarchar(50) = NULL,
		@c33 nvarchar(50) = NULL,
		@c34 nvarchar(50) = NULL,
		@c35 nvarchar(2) = NULL,
		@c36 nvarchar(10) = NULL,
		@c37 nvarchar(15) = NULL,
		@c38 nvarchar(15) = NULL,
		@c39 nvarchar(15) = NULL,
		@c40 bit = NULL,
		@c41 bit = NULL,
		@c42 bit = NULL,
		@c43 bit = NULL,
		@c44 bit = NULL,
		@c45 bit = NULL,
		@c46 datetime = NULL,
		@c47 nvarchar(50) = NULL,
		@c48 nvarchar(50) = NULL,
		@c49 nvarchar(50) = NULL,
		@c50 nvarchar(50) = NULL,
		@c51 nvarchar(50) = NULL,
		@c52 nvarchar(20) = NULL,
		@c53 bit = NULL,
		@c54 int = NULL,
		@c55 nvarchar(25) = NULL,
		@c56 nvarchar(100) = NULL,
		@c57 nvarchar(50) = NULL,
		@c58 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(8)
as
begin
	declare @primarykey_text nvarchar(100) = ''
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
		[ConsultationStatusDate] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [ConsultationStatusDate] end,
		[WarningMessage] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [WarningMessage] end,
		[Gender] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [Gender] end,
		[LastName] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [LastName] end,
		[FirstName] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [FirstName] end,
		[Address1] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [Address1] end,
		[Address2] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [Address2] end,
		[City] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [City] end,
		[State] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [State] end,
		[ZipCode] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [ZipCode] end,
		[HomePhone] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [HomePhone] end,
		[WorkPhone] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [WorkPhone] end,
		[CellPhone] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [CellPhone] end,
		[HomePhoneDNC] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [HomePhoneDNC] end,
		[WorkPhoneDNC] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [WorkPhoneDNC] end,
		[CellPhoneDNC] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [CellPhoneDNC] end,
		[HomePhoneFTCDNC] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [HomePhoneFTCDNC] end,
		[WorkPhoneFTCDNC] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [WorkPhoneFTCDNC] end,
		[CellPhoneFTCDNC] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [CellPhoneFTCDNC] end,
		[MembershipStartDate] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [MembershipStartDate] end,
		[SalesUserName] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [SalesUserName] end,
		[SalesOfficeName] = case substring(@bitmap,6,1) & 128 when 128 then @c48 else [SalesOfficeName] end,
		[HC_Center] = case substring(@bitmap,7,1) & 1 when 1 then @c49 else [HC_Center] end,
		[ProcedureOffice] = case substring(@bitmap,7,1) & 2 when 2 then @c50 else [ProcedureOffice] end,
		[ConsultOffice] = case substring(@bitmap,7,1) & 4 when 4 then @c51 else [ConsultOffice] end,
		[BosleyProcedureID] = case substring(@bitmap,7,1) & 8 when 8 then @c52 else [BosleyProcedureID] end,
		[IsRealTimeRequest] = case substring(@bitmap,7,1) & 16 when 16 then @c53 else [IsRealTimeRequest] end,
		[BosleyRealTimeRequestID] = case substring(@bitmap,7,1) & 32 when 32 then @c54 else [BosleyRealTimeRequestID] end,
		[OnContactContactID] = case substring(@bitmap,7,1) & 64 when 64 then @c55 else [OnContactContactID] end,
		[EmailAddress] = case substring(@bitmap,7,1) & 128 when 128 then @c56 else [EmailAddress] end,
		[BosleySalesforceAccountID] = case substring(@bitmap,8,1) & 1 when 1 then @c57 else [BosleySalesforceAccountID] end,
		[HCSalesforceLeadID] = case substring(@bitmap,8,1) & 2 when 2 then @c58 else [HCSalesforceLeadID] end
	where [IncomingRequestID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[IncomingRequestID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datIncomingRequestLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO