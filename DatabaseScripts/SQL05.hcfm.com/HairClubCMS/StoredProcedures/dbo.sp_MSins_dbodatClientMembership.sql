/* CreateDate: 05/05/2020 17:42:45.830 , ModifyDate: 05/05/2020 17:42:45.830 */
GO
create procedure [sp_MSins_dbodatClientMembership]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 uniqueidentifier,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 money,
    @c8 money,
    @c9 money,
    @c10 date,
    @c11 date,
    @c12 int,
    @c13 datetime,
    @c14 bit,
    @c15 bit,
    @c16 bit,
    @c17 int,
    @c18 bit,
    @c19 datetime,
    @c20 nvarchar(25),
    @c21 datetime,
    @c22 nvarchar(25),
    @c23 nvarchar(50),
    @c24 nvarchar(100),
    @c25 bit,
    @c26 money,
    @c27 int
as
begin
	insert into [dbo].[datClientMembership] (
		[ClientMembershipGUID],
		[Member1_ID_Temp],
		[ClientGUID],
		[CenterID],
		[MembershipID],
		[ClientMembershipStatusID],
		[ContractPrice],
		[ContractPaidAmount],
		[MonthlyFee],
		[BeginDate],
		[EndDate],
		[MembershipCancelReasonID],
		[CancelDate],
		[IsGuaranteeFlag],
		[IsRenewalFlag],
		[IsMultipleSurgeryFlag],
		[RenewalCount],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ClientMembershipIdentifier],
		[MembershipCancelReasonDescription],
		[HasInHousePaymentPlan],
		[NationalMonthlyFee],
		[MembershipProfileTypeID]
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
		default,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27	)
end
GO
