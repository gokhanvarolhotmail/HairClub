/* CreateDate: 05/05/2020 17:42:51.737 , ModifyDate: 05/05/2020 17:42:51.737 */
GO
create procedure [dbo].[sp_MSins_dbodatPaymentPlan]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 int,
    @c5 money,
    @c6 money,
    @c7 int,
    @c8 int,
    @c9 datetime,
    @c10 datetime,
    @c11 datetime,
    @c12 money,
    @c13 datetime,
    @c14 nvarchar(25),
    @c15 datetime,
    @c16 nvarchar(25),
    @c17 binary(8)
as
begin
	insert into [dbo].[datPaymentPlan] (
		[PaymentPlanID],
		[ClientGUID],
		[ClientMembershipGUID],
		[PaymentPlanStatusID],
		[ContractAmount],
		[DownpaymentAmount],
		[TotalNumberOfPayments],
		[RemainingNumberOfPayments],
		[StartDate],
		[SatisfactionDate],
		[CancelDate],
		[RemainingBalance],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp]
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
		@c17	)
end
GO
