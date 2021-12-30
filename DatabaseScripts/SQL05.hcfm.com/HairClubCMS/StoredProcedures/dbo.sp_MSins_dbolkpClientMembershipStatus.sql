/* CreateDate: 05/05/2020 17:42:44.523 , ModifyDate: 05/05/2020 17:42:44.523 */
GO
create procedure [sp_MSins_dbolkpClientMembershipStatus]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 bit,
    @c12 bit,
    @c13 nvarchar(100)
as
begin
	insert into [dbo].[lkpClientMembershipStatus] (
		[ClientMembershipStatusID],
		[ClientMembershipStatusSortOrder],
		[ClientMembershipStatusDescription],
		[ClientMembershipStatusDescriptionShort],
		[IsActiveMembershipFlag],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[CanSearchAndDisplayFlag],
		[CanCheckInForConsultation],
		[DescriptionResourceKey]
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
		default,
		@c11,
		@c12,
		@c13	)
end
GO
