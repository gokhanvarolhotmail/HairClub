/* CreateDate: 05/05/2020 17:42:49.453 , ModifyDate: 05/05/2020 17:42:49.453 */
GO
create procedure [sp_MSins_dbodatClientTransaction]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 datetime,
    @c4 int,
    @c5 datetime,
    @c6 datetime,
    @c7 datetime,
    @c8 datetime,
    @c9 datetime,
    @c10 datetime,
    @c11 datetime,
    @c12 datetime,
    @c13 nvarchar(4),
    @c14 nvarchar(4),
    @c15 date,
    @c16 date,
    @c17 int,
    @c18 int,
    @c19 datetime,
    @c20 nvarchar(25),
    @c21 datetime,
    @c22 nvarchar(25),
    @c23 money,
    @c24 money,
    @c25 nvarchar(100),
    @c26 nvarchar(100),
    @c27 nvarchar(4),
    @c28 nvarchar(4),
    @c29 int,
    @c30 int
as
begin
	insert into [dbo].[datClientTransaction] (
		[ClientTransactionGUID],
		[ClientGUID],
		[TransactionDate],
		[ClientProcessID],
		[EFTFreezeStartDate],
		[PreviousEFTFreezeStartDate],
		[EFTFreezeEndDate],
		[PreviousEFTFreezeEndDate],
		[EFTHoldStartDate],
		[PreviousEFTHoldStartDate],
		[EFTHoldEndDate],
		[PreviousEFTHoldEndDate],
		[CCNumber],
		[PreviousCCNumber],
		[CCExpirationDate],
		[PreviousCCExpirationDate],
		[FeePayCycleId],
		[PreviousFeePayCycleId],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[MonthlyFeeAmount],
		[PreviousMonthlyFeeAmount],
		[PreviousFeeFreezeReasonDescription],
		[FeeFreezeReasonDescription],
		[BankAccountNumber],
		[PreviousBankAccountNumber],
		[FeeFreezeReasonID],
		[PreviousFeeFreezeReasonID]
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
		@c30	)
end
GO
