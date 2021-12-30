/* CreateDate: 05/05/2020 17:42:50.723 , ModifyDate: 05/05/2020 17:42:50.723 */
GO
create procedure [sp_MSins_dbodatPurchaseOrder]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 datetime,
    @c4 int,
    @c5 money,
    @c6 int,
    @c7 int,
    @c8 uniqueidentifier,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 int,
    @c14 int
as
begin
	insert into [dbo].[datPurchaseOrder] (
		[PurchaseOrderGUID],
		[VendorID],
		[PurchaseOrderDate],
		[PurchaseOrderNumber],
		[PurchaseOrderTotal],
		[PurchaseOrderCount],
		[PurchaseOrderStatusID],
		[HairSystemAllocationGUID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[PurchaseOrderTypeID],
		[PurchaseOrderNumberOriginal]
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
		default,
		@c13,
		@c14	)
end
GO
