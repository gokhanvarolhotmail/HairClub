/* CreateDate: 05/05/2020 17:42:55.673 , ModifyDate: 05/05/2020 17:42:55.673 */
GO
create procedure [dbo].[sp_MSins_dbodatSerializedInventoryAuditBatch]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 datetime,
    @c6 uniqueidentifier,
    @c7 bit,
    @c8 datetime,
    @c9 uniqueidentifier,
    @c10 bit,
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 datetime,
    @c14 nvarchar(25),
    @c15 binary(8)
as
begin
	insert into [dbo].[datSerializedInventoryAuditBatch] (
		[SerializedInventoryAuditBatchID],
		[SerializedInventoryAuditSnapshotID],
		[CenterID],
		[InventoryAuditBatchStatusID],
		[CompleteDate],
		[CompletedByEmployeeGUID],
		[IsReviewCompleted],
		[ReviewCompleteDate],
		[ReviewCompletedByEmployeeGUID],
		[IsAdjustmentCompleted],
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
		@c15	)
end
GO
