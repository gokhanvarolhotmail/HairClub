/* CreateDate: 05/05/2020 17:42:48.970 , ModifyDate: 05/05/2020 17:42:48.970 */
GO
create procedure [sp_MSins_dbolkpOccupation]
    @c1 int,
    @c2 nvarchar(10),
    @c3 int,
    @c4 nvarchar(100),
    @c5 nvarchar(10),
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 nvarchar(100)
as
begin
	insert into [dbo].[lkpOccupation] (
		[OccupationID],
		[BOSOccupationCode],
		[OccupationSortOrder],
		[OccupationDescription],
		[OccupationDescriptionShort],
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
		default,
		@c11	)
end
GO
