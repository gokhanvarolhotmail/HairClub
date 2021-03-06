/* CreateDate: 05/05/2020 17:42:38.540 , ModifyDate: 05/05/2020 17:42:38.540 */
GO
create procedure [dbo].[sp_MSins_dbocfgAddOn]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 int,
    @c6 money,
    @c7 money,
    @c8 money,
    @c9 int,
    @c10 int,
    @c11 bit,
    @c12 bit,
    @c13 datetime,
    @c14 nvarchar(25),
    @c15 datetime,
    @c16 nvarchar(25),
    @c17 binary(8),
    @c18 bit,
    @c19 int,
    @c20 int,
    @c21 bit,
    @c22 int
as
begin
	insert into [dbo].[cfgAddOn] (
		[AddOnID],
		[AddOnSortOrder],
		[AddOnDescription],
		[AddOnDescriptionShort],
		[AddOnTypeID],
		[PriceDefault],
		[PriceMinimum],
		[PriceMaximum],
		[QuantityMinimum],
		[QuantityMaximum],
		[CarryOverToNewMembership],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsMultipleAddAllowed],
		[PaymentSalesCodeID],
		[MonthlyFeeSalesCodeID],
		[CarryOverRemainingBenefitsToNewMembership],
		[QuantityIntervalMultiplier]
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
		@c22	)
end
GO
