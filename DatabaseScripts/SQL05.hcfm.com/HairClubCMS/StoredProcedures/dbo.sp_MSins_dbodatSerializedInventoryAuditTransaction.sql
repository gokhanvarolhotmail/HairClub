/* CreateDate: 05/05/2020 17:42:55.723 , ModifyDate: 05/05/2020 17:42:55.723 */
GO
create procedure [dbo].[sp_MSins_dbodatSerializedInventoryAuditTransaction]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 bit,
    @c6 nvarchar(200),
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 binary(8)
as
begin
	insert into [dbo].[datSerializedInventoryAuditTransaction] (
		[SerializedInventoryAuditTransactionID],
		[SerializedInventoryAuditBatchID],
		[SalesCodeID],
		[QuantityExpected],
		[IsExcludedFromCorrections],
		[ExclusionReason],
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
		@c11	)
end
GO
