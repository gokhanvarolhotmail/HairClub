/* CreateDate: 05/05/2020 17:42:50.817 , ModifyDate: 05/05/2020 17:42:50.817 */
GO
create procedure [sp_MSins_dbodatPurchaseOrderDetail]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 int,
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25)
as
begin
	insert into [dbo].[datPurchaseOrderDetail] (
		[PurchaseOrderDetailGUID],
		[PurchaseOrderGUID],
		[HairSystemOrderGUID],
		[HairSystemAllocationFilterID],
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
		default	)
end
GO
