/* CreateDate: 05/05/2020 17:42:45.510 , ModifyDate: 05/05/2020 17:42:45.510 */
GO
create procedure [sp_MSins_dbodatAccountingExportBatch]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 int,
    @c4 datetime,
    @c5 datetime,
    @c6 datetime,
    @c7 datetime,
    @c8 nvarchar(200),
    @c9 money,
    @c10 money,
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 datetime,
    @c14 nvarchar(25)
as
begin
	insert into [dbo].[datAccountingExportBatch] (
		[AccountingExportBatchGUID],
		[AccountingExportBatchTypeID],
		[AccountingExportBatchNumber],
		[BatchRunDate],
		[BatchBeginDate],
		[BatchEndDate],
		[BatchInvoiceDate],
		[ExportFileName],
		[InvoiceAmount],
		[FreightAmount],
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
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		default	)
end
GO
