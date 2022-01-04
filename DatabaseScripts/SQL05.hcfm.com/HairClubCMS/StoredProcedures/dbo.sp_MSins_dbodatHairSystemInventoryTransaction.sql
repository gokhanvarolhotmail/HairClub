/* CreateDate: 05/05/2020 17:42:50.200 , ModifyDate: 05/05/2020 17:42:50.200 */
GO
create procedure [sp_MSins_dbodatHairSystemInventoryTransaction]
    @c1 int,
    @c2 int,
    @c3 uniqueidentifier,
    @c4 nvarchar(50),
    @c5 int,
    @c6 bit,
    @c7 uniqueidentifier,
    @c8 uniqueidentifier,
    @c9 int,
    @c10 int,
    @c11 datetime,
    @c12 uniqueidentifier,
    @c13 int,
    @c14 int,
    @c15 bit,
    @c16 nvarchar(200),
    @c17 datetime,
    @c18 nvarchar(25),
    @c19 datetime,
    @c20 nvarchar(25),
    @c21 bit
as
begin
	insert into [dbo].[datHairSystemInventoryTransaction] (
		[HairSystemInventoryTransactionID],
		[HairSystemInventoryBatchID],
		[HairSystemOrderGUID],
		[HairSystemOrderNumber],
		[HairSystemOrderStatusID],
		[IsInTransit],
		[ClientGUID],
		[ClientMembershipGUID],
		[ClientIdentifier],
		[ClientHomeCenterID],
		[ScannedDate],
		[ScannedEmployeeGUID],
		[ScannedCenterID],
		[ScannedHairSystemInventoryBatchID],
		[IsExcludedFromCorrections],
		[ExclusionReason],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[IsScannedEntry]
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
		default,
		@c21	)
end
GO