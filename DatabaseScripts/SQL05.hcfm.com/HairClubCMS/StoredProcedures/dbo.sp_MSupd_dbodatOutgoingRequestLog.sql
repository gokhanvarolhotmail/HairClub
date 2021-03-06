/* CreateDate: 05/05/2020 17:42:51.507 , ModifyDate: 05/05/2020 17:42:51.507 */
GO
create procedure [sp_MSupd_dbodatOutgoingRequestLog]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 nvarchar(1) = NULL,
		@c7 nvarchar(10) = NULL,
		@c8 nvarchar(50) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(10) = NULL,
		@c12 nvarchar(10) = NULL,
		@c13 nvarchar(10) = NULL,
		@c14 nvarchar(10) = NULL,
		@c15 nvarchar(15) = NULL,
		@c16 nvarchar(15) = NULL,
		@c17 nvarchar(15) = NULL,
		@c18 nvarchar(100) = NULL,
		@c19 datetime = NULL,
		@c20 datetime = NULL,
		@c21 datetime = NULL,
		@c22 varchar(5000) = NULL,
		@c23 nvarchar(50) = NULL,
		@c24 nvarchar(50) = NULL,
		@c25 datetime = NULL,
		@c26 nvarchar(25) = NULL,
		@c27 nvarchar(50) = NULL,
		@c28 int = NULL,
		@c29 nvarchar(50) = NULL,
		@c30 nvarchar(50) = NULL,
		@c31 decimal(33,6) = NULL,
		@c32 nvarchar(500) = NULL,
		@c33 nvarchar(100) = NULL,
		@c34 int = NULL,
		@c35 decimal(21,6) = NULL,
		@c36 int = NULL,
		@c37 decimal(21,6) = NULL,
		@c38 int = NULL,
		@c39 nvarchar(3) = NULL,
		@c40 datetime = NULL,
		@c41 nvarchar(25) = NULL,
		@c42 datetime = NULL,
		@c43 nvarchar(25) = NULL,
		@c44 int = NULL,
		@c45 datetime = NULL,
		@c46 nvarchar(50) = NULL,
		@c47 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(6)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[datOutgoingRequestLog] set
		[OnContactID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [OnContactID] end,
		[SalutationDescriptionShort] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SalutationDescriptionShort] end,
		[LastName] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LastName] end,
		[Firstname] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Firstname] end,
		[MiddleInitial] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [MiddleInitial] end,
		[GenderDescriptionShort] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [GenderDescriptionShort] end,
		[Address1] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Address1] end,
		[Address2] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Address2] end,
		[City] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [City] end,
		[ProvinceDecriptionShort] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [ProvinceDecriptionShort] end,
		[StateDescriptionShort] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [StateDescriptionShort] end,
		[PostalCode] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PostalCode] end,
		[CountryDescriptionShort] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CountryDescriptionShort] end,
		[HomePhone] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [HomePhone] end,
		[WorkPhone] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [WorkPhone] end,
		[MobilePhone] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [MobilePhone] end,
		[EmailAddress] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [EmailAddress] end,
		[HomePhoneAuth] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [HomePhoneAuth] end,
		[WorkPhoneAuth] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [WorkPhoneAuth] end,
		[CellPhoneAuth] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CellPhoneAuth] end,
		[ConsultationNotes] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [ConsultationNotes] end,
		[ConsultOffice] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [ConsultOffice] end,
		[ConsultantUsername] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [ConsultantUsername] end,
		[LeadCreatedDate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [LeadCreatedDate] end,
		[ProcessName] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [ProcessName] end,
		[SiebelID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [SiebelID] end,
		[ClientIdentifier] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [ClientIdentifier] end,
		[ClientMembershipIdentifier] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [ClientMembershipIdentifier] end,
		[InvoiceNumber] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [InvoiceNumber] end,
		[Amount] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [Amount] end,
		[TenderTypeDescriptionShort] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [TenderTypeDescriptionShort] end,
		[FinanceCompany] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [FinanceCompany] end,
		[EstGraftCount] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [EstGraftCount] end,
		[EstContractTotal] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [EstContractTotal] end,
		[PrevGraftCount] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [PrevGraftCount] end,
		[PrevContractTotal] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [PrevContractTotal] end,
		[PrevNumOfProcedures] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [PrevNumOfProcedures] end,
		[PostExtremeFlag] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [PostExtremeFlag] end,
		[CreateDate] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,6,1) & 1 when 1 then @c41 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,6,1) & 2 when 2 then @c42 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,6,1) & 4 when 4 then @c43 else [LastUpdateUser] end,
		[RequestQueueID] = case substring(@bitmap,6,1) & 8 when 8 then @c44 else [RequestQueueID] end,
		[ConsultDate] = case substring(@bitmap,6,1) & 16 when 16 then @c45 else [ConsultDate] end,
		[BosleySalesforceAccountID] = case substring(@bitmap,6,1) & 32 when 32 then @c46 else [BosleySalesforceAccountID] end,
		[HCSalesforceLeadID] = case substring(@bitmap,6,1) & 64 when 64 then @c47 else [HCSalesforceLeadID] end
	where [OutgoingRequestID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[OutgoingRequestID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datOutgoingRequestLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
