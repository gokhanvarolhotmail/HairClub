/* CreateDate: 05/05/2020 17:42:51.103 , ModifyDate: 05/05/2020 17:42:51.103 */
GO
create procedure [sp_MSins_dbodatInvoice]
    @c1 uniqueidentifier,
    @c2 nvarchar(20),
    @c3 datetime,
    @c4 nvarchar(50),
    @c5 int,
    @c6 money,
    @c7 int,
    @c8 nvarchar(50),
    @c9 datetime,
    @c10 nvarchar(100),
    @c11 datetime,
    @c12 nvarchar(100),
    @c13 nvarchar(50)
as
begin
	insert into [dbo].[datInvoice] (
		[InvoiceGUID],
		[InvoiceNumber],
		[InvoiceDate],
		[InvoiceDescription],
		[OrderCount],
		[TotalInvoiceValue],
		[ShipmentMethodID],
		[TrackingNumber],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[PurchaseOrderNumber],
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
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		default	)
end
GO
