/* CreateDate: 05/05/2020 17:42:51.493 , ModifyDate: 05/05/2020 17:42:51.493 */
GO
create procedure [sp_MSins_dbodatOutgoingRequestLog]
    @c1 int,
    @c2 nvarchar(50),
    @c3 nvarchar(10),
    @c4 nvarchar(50),
    @c5 nvarchar(50),
    @c6 nvarchar(1),
    @c7 nvarchar(10),
    @c8 nvarchar(50),
    @c9 nvarchar(50),
    @c10 nvarchar(50),
    @c11 nvarchar(10),
    @c12 nvarchar(10),
    @c13 nvarchar(10),
    @c14 nvarchar(10),
    @c15 nvarchar(15),
    @c16 nvarchar(15),
    @c17 nvarchar(15),
    @c18 nvarchar(100),
    @c19 datetime,
    @c20 datetime,
    @c21 datetime,
    @c22 varchar(5000),
    @c23 nvarchar(50),
    @c24 nvarchar(50),
    @c25 datetime,
    @c26 nvarchar(25),
    @c27 nvarchar(50),
    @c28 int,
    @c29 nvarchar(50),
    @c30 nvarchar(50),
    @c31 decimal(33,6),
    @c32 nvarchar(500),
    @c33 nvarchar(100),
    @c34 int,
    @c35 decimal(21,6),
    @c36 int,
    @c37 decimal(21,6),
    @c38 int,
    @c39 nvarchar(3),
    @c40 datetime,
    @c41 nvarchar(25),
    @c42 datetime,
    @c43 nvarchar(25),
    @c44 int,
    @c45 datetime,
    @c46 nvarchar(50),
    @c47 nvarchar(50)
as
begin
	insert into [dbo].[datOutgoingRequestLog] (
		[OutgoingRequestID],
		[OnContactID],
		[SalutationDescriptionShort],
		[LastName],
		[Firstname],
		[MiddleInitial],
		[GenderDescriptionShort],
		[Address1],
		[Address2],
		[City],
		[ProvinceDecriptionShort],
		[StateDescriptionShort],
		[PostalCode],
		[CountryDescriptionShort],
		[HomePhone],
		[WorkPhone],
		[MobilePhone],
		[EmailAddress],
		[HomePhoneAuth],
		[WorkPhoneAuth],
		[CellPhoneAuth],
		[ConsultationNotes],
		[ConsultOffice],
		[ConsultantUsername],
		[LeadCreatedDate],
		[ProcessName],
		[SiebelID],
		[ClientIdentifier],
		[ClientMembershipIdentifier],
		[InvoiceNumber],
		[Amount],
		[TenderTypeDescriptionShort],
		[FinanceCompany],
		[EstGraftCount],
		[EstContractTotal],
		[PrevGraftCount],
		[PrevContractTotal],
		[PrevNumOfProcedures],
		[PostExtremeFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[RequestQueueID],
		[ConsultDate],
		[BosleySalesforceAccountID],
		[HCSalesforceLeadID]
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
		@c40,
		@c41,
		@c42,
		@c43,
		default,
		@c44,
		@c45,
		@c46,
		@c47	)
end
GO
