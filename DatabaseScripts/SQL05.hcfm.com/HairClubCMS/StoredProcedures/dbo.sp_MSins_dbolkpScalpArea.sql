/* CreateDate: 05/05/2020 17:42:55.230 , ModifyDate: 05/05/2020 17:42:55.230 */
GO
create procedure [sp_MSins_dbolkpScalpArea]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 nvarchar(100)
as
begin
	insert into [dbo].[lkpScalpArea] (
		[ScalpAreaID],
		[ScalpAreaSortOrder],
		[ScalpAreaDescription],
		[ScalpAreaDescriptionShort],
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
		default,
		@c10	)
end
GO