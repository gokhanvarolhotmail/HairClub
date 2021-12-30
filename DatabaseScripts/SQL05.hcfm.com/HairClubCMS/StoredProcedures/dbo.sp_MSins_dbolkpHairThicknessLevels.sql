/* CreateDate: 05/05/2020 17:42:54.210 , ModifyDate: 05/05/2020 17:42:54.210 */
GO
create procedure [sp_MSins_dbolkpHairThicknessLevels]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 nvarchar(200),
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 decimal(18,0),
    @c12 decimal(18,0),
    @c13 nvarchar(100),
    @c14 nvarchar(100)
as
begin
	insert into [dbo].[lkpHairThicknessLevels] (
		[HairThicknessLevelsID],
		[HairThicknessLevelsSortOrder],
		[HairThicknessLevelsDescription],
		[HairThicknessLevelsDescriptionShort],
		[HairThicknessLevelsDescriptionLong],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[MinValue],
		[MaxValue],
		[DescriptionResourceKey],
		[DescriptionLongResourceKey]
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
		@c13,
		@c14	)
end
GO
