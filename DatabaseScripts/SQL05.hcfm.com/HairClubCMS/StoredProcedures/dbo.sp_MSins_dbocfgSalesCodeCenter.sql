/* CreateDate: 05/05/2020 17:42:44.743 , ModifyDate: 05/05/2020 17:42:44.743 */
GO
create procedure [sp_MSins_dbocfgSalesCodeCenter]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 money,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 bit,
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25),
    @c14 int,
    @c15 money
as
begin
	insert into [dbo].[cfgSalesCodeCenter] (
		[SalesCodeCenterID],
		[CenterID],
		[SalesCodeID],
		[PriceRetail],
		[TaxRate1ID],
		[TaxRate2ID],
		[QuantityMaxLevel],
		[QuantityMinLevel],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[AgreementID],
		[CenterCost]
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
		default,
		@c14,
		@c15	)
end
GO
