/* CreateDate: 05/05/2020 17:42:49.310 , ModifyDate: 05/05/2020 17:42:49.310 */
GO
create procedure [sp_MSins_dbodatClientMembershipAccum]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 decimal(21,6),
    @c6 datetime,
    @c7 int,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 int
as
begin
	insert into [dbo].[datClientMembershipAccum] (
		[ClientMembershipAccumGUID],
		[ClientMembershipGUID],
		[AccumulatorID],
		[UsedAccumQuantity],
		[AccumMoney],
		[AccumDate],
		[TotalAccumQuantity],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ClientMembershipAddOnID]
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
		default,
		@c12	)
end
GO
