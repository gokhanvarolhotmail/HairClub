/* CreateDate: 05/05/2020 17:42:40.373 , ModifyDate: 05/05/2020 17:42:40.373 */
GO
create procedure [dbo].[sp_MSins_dbocfgMembership]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 nvarchar(10),
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 money,
    @c10 money,
    @c11 bit,
    @c12 bit,
    @c13 bit,
    @c14 datetime,
    @c15 nvarchar(25),
    @c16 datetime,
    @c17 nvarchar(25),
    @c18 binary(8),
    @c19 bit,
    @c20 int,
    @c21 int,
    @c22 int,
    @c23 int,
    @c24 bit,
    @c25 int,
    @c26 int,
    @c27 int,
    @c28 int,
    @c29 int,
    @c30 nvarchar(10)
as
begin
	insert into [dbo].[cfgMembership] (
		[MembershipID],
		[MembershipSortOrder],
		[MembershipDescription],
		[MembershipDescriptionShort],
		[BusinessSegmentID],
		[RevenueGroupID],
		[GenderID],
		[DurationMonths],
		[ContractPrice],
		[MonthlyFee],
		[IsTaxableFlag],
		[IsDefaultMembershipFlag],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsHairSystemOrderRushFlag],
		[HairSystemGeneralLedgerID],
		[DefaultPaymentSalesCodeID],
		[NumRenewalDays],
		[NumDaysAfterCancelBeforeNew],
		[CanCheckinForConsultation],
		[MaximumHairSystemHairLengthValue],
		[ExpectedConversionDays],
		[MinimumAge],
		[MaximumAge],
		[MaximumLongHairAddOnHairLengthValue],
		[BOSSalesTypeCode]
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
