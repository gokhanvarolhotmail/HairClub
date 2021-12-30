/* CreateDate: 05/05/2020 17:42:50.913 , ModifyDate: 05/05/2020 17:42:50.913 */
GO
create procedure [sp_MSins_dbodatHairSystemOrderTransaction]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 int,
    @c4 uniqueidentifier,
    @c5 uniqueidentifier,
    @c6 datetime,
    @c7 int,
    @c8 uniqueidentifier,
    @c9 int,
    @c10 uniqueidentifier,
    @c11 int,
    @c12 int,
    @c13 uniqueidentifier,
    @c14 uniqueidentifier,
    @c15 uniqueidentifier,
    @c16 money,
    @c17 money,
    @c18 money,
    @c19 money,
    @c20 money,
    @c21 money,
    @c22 uniqueidentifier,
    @c23 datetime,
    @c24 nvarchar(25),
    @c25 datetime,
    @c26 nvarchar(25),
    @c27 money,
    @c28 money,
    @c29 uniqueidentifier,
    @c30 int
as
begin
	insert into [dbo].[datHairSystemOrderTransaction] (
		[HairSystemOrderTransactionGUID],
		[CenterID],
		[ClientHomeCenterID],
		[ClientGUID],
		[ClientMembershipGUID],
		[HairSystemOrderTransactionDate],
		[HairSystemOrderProcessID],
		[HairSystemOrderGUID],
		[PreviousCenterID],
		[PreviousClientMembershipGUID],
		[PreviousHairSystemOrderStatusID],
		[NewHairSystemOrderStatusID],
		[InventoryShipmentDetailGUID],
		[InventoryTransferRequestGUID],
		[PurchaseOrderDetailGUID],
		[CostContract],
		[PreviousCostContract],
		[CostActual],
		[PreviousCostActual],
		[CenterPrice],
		[PreviousCenterPrice],
		[EmployeeGUID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[CostFactoryShipped],
		[PreviousCostFactoryShipped],
		[SalesOrderDetailGuid],
		[HairSystemOrderPriorityReasonID]
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
		default,
		@c27,
		@c28,
		@c29,
		@c30	)
end
GO
