/* CreateDate: 05/05/2020 17:42:47.917 , ModifyDate: 05/05/2020 17:42:47.917 */
GO
create procedure [sp_MSins_dbodatAccountReceivable]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 uniqueidentifier,
    @c5 money,
    @c6 bit,
    @c7 int,
    @c8 money,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 uniqueidentifier,
    @c14 uniqueidentifier,
    @c15 uniqueidentifier,
    @c16 uniqueidentifier,
    @c17 uniqueidentifier
as
begin
	insert into [dbo].[datAccountReceivable] (
		[AccountReceivableID],
		[ClientGUID],
		[SalesOrderGUID],
		[CenterFeeBatchGUID],
		[Amount],
		[IsClosed],
		[AccountReceivableTypeID],
		[RemainingBalance],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[CenterDeclineBatchGUID],
		[RefundedSalesOrderGuid],
		[WriteOffSalesOrderGUID],
		[NSFSalesOrderGUID],
		[ChargeBackSalesOrderGUID]
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
		@c14,
		@c15,
		@c16,
		@c17	)
end
GO
