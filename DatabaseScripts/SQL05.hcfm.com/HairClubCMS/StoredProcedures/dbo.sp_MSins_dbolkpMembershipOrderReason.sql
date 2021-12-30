/* CreateDate: 05/05/2020 17:42:45.780 , ModifyDate: 05/05/2020 17:42:45.780 */
GO
create procedure [sp_MSins_dbolkpMembershipOrderReason]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 nvarchar(100),
    @c5 nvarchar(10),
    @c6 int,
    @c7 int,
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25)
as
begin
	insert into [dbo].[lkpMembershipOrderReason] (
		[MembershipOrderReasonID],
		[MembershipOrderReasonTypeID],
		[MembershipOrderReasonSortOrder],
		[MembershipOrderReasonDescription],
		[MembershipOrderReasonDescriptionShort],
		[BusinessSegmentID],
		[RevenueTypeID],
		[IsActiveFlag],
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
		default	)
end
GO
