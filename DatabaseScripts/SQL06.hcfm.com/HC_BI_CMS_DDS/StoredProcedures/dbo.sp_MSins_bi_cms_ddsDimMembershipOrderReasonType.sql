/* CreateDate: 03/17/2022 11:57:06.503 , ModifyDate: 03/17/2022 11:57:06.503 */
GO
create procedure [sp_MSins_bi_cms_ddsDimMembershipOrderReasonType]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [bi_cms_dds].[DimMembershipOrderReasonType] (
		[MembershipOrderReasonTypeID],
		[MembershipOrderReasonTypeSortOrder],
		[MembershipOrderReasonTypeDescription],
		[MembershipOrderReasonTypeDescriptionShort],
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
