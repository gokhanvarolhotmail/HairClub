/* CreateDate: 05/05/2020 17:42:51.153 , ModifyDate: 05/05/2020 17:42:51.153 */
GO
create procedure [sp_MSins_dbodatInvoiceDetail]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 nvarchar(100),
    @c4 uniqueidentifier,
    @c5 datetime,
    @c6 nvarchar(100),
    @c7 datetime,
    @c8 nvarchar(100)
as
begin
	insert into [dbo].[datInvoiceDetail] (
		[InvoiceDetailGUID],
		[InvoiceGUID],
		[HairSystemOrderNumber],
		[HairSystemOrderGUID],
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
