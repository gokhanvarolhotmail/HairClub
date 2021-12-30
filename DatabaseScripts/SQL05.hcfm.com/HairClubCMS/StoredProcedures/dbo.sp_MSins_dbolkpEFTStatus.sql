/* CreateDate: 05/05/2020 17:42:49.123 , ModifyDate: 05/05/2020 17:42:49.123 */
GO
create procedure [sp_MSins_dbolkpEFTStatus]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 bit,
    @c7 bit,
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25),
    @c13 nvarchar(100)
as
begin
	insert into [dbo].[lkpEFTStatus] (
		[EFTStatusID],
		[EFTStatusSortOrder],
		[EFTStatusDescription],
		[EFTStatusDescriptionShort],
		[IsCardDeclinedFlag],
		[IsEFTActiveFlag],
		[IsFrozenFlag],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
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
		@c11,
		@c12,
		default,
		@c13	)
end
GO
