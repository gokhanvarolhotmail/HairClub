/* CreateDate: 05/05/2020 17:42:46.733 , ModifyDate: 05/05/2020 17:42:46.733 */
GO
create procedure [sp_MSins_dbodatAccountingExportBatchDetail]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 uniqueidentifier,
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 money,
    @c10 uniqueidentifier,
    @c11 int
as
begin
	insert into [dbo].[datAccountingExportBatchDetail] (
		[AccountingExportBatchDetailGUID],
		[AccountingExportBatchGUID],
		[HairSystemOrderGUID],
		[HairSystemOrderTransactionGUID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[FreightAmount],
		[InventoryShipmentGUID],
		[CenterID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		default,
		@c9,
		@c10,
		@c11	)
end
GO
