/* CreateDate: 05/05/2020 17:42:51.057 , ModifyDate: 05/05/2020 17:42:51.057 */
GO
create procedure [sp_MSins_dbodatInventoryTransaction]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 datetime,
    @c6 int,
    @c7 bit,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 int
as
begin
	insert into [dbo].[datInventoryTransaction] (
		[InventoryTransactionGUID],
		[EmployeeGUID],
		[SalesCodeCenterID],
		[InventoryTransactionTypeID],
		[InventoryTransactionDate],
		[QuantityAdjustment],
		[ResetQuantityFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[HairSystemHoldReasonID]
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
		default,
		@c12	)
end
GO
