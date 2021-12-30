/* CreateDate: 05/05/2020 17:42:41.017 , ModifyDate: 05/05/2020 17:42:41.017 */
GO
create procedure [sp_MSins_dbocfgCenterMembershipRuleExclusion]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[cfgCenterMembershipRuleExclusion] (
		[CenterMembershipRuleExclusionID],
		[CenterMembershipID],
		[MembershipRuleTypeID],
		[NewMembershipID],
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
		default	)
end
GO
