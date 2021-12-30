/* CreateDate: 05/05/2020 17:42:50.587 , ModifyDate: 05/05/2020 17:42:50.587 */
GO
create procedure [sp_MSins_dbodatInventoryShipmentDetail]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 int,
    @c5 uniqueidentifier,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 int,
    @c11 money,
    @c12 int
as
begin
	insert into [dbo].[datInventoryShipmentDetail] (
		[InventoryShipmentDetailGUID],
		[InventoryShipmentGUID],
		[HairSystemOrderGUID],
		[InventoryShipmentDetailStatusID],
		[InventoryTransferRequestGUID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[InventoryShipmentReasonID],
		[PriorityTransferFee],
		[PriorityHairSystemCenterContractPricingID]
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
		default,
		@c10,
		@c11,
		@c12	)
end
GO
