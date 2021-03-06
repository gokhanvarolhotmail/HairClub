/* CreateDate: 05/05/2020 17:42:55.773 , ModifyDate: 05/05/2020 17:42:55.773 */
GO
create procedure [dbo].[sp_MSins_dbodatSerializedInventoryAuditTransactionSerialized]
    @c1 int,
    @c2 int,
    @c3 nvarchar(50),
    @c4 bit,
    @c5 int,
    @c6 nvarchar(200),
    @c7 int,
    @c8 nvarchar(200),
    @c9 bit,
    @c10 datetime,
    @c11 uniqueidentifier,
    @c12 int,
    @c13 int,
    @c14 bit,
    @c15 int,
    @c16 bit,
    @c17 datetime,
    @c18 nvarchar(25),
    @c19 datetime,
    @c20 nvarchar(25),
    @c21 binary(8)
as
begin
	insert into [dbo].[datSerializedInventoryAuditTransactionSerialized] (
		[SerializedInventoryAuditTransactionSerializedID],
		[SerializedInventoryAuditTransactionID],
		[SerialNumber],
		[IsInTransit],
		[SerializedInventoryStatusID],
		[ExclusionReason],
		[InventoryNotScannedReasonID],
		[InventoryNotScannedNote],
		[IsScannedEntry],
		[ScannedDate],
		[ScannedEmployeeGUID],
		[ScannedCenterID],
		[ScannedSerializedInventoryAuditBatchID],
		[DeviceAddedAfterSnapshotTaken],
		[InventoryAdjustmentIdAtTimeOfSnapshot],
		[IsExcludedFromCorrections],
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
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21	)
end
GO
