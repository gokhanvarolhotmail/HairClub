/* CreateDate: 05/05/2020 17:42:55.000 , ModifyDate: 05/05/2020 17:42:55.000 */
GO
create procedure [sp_MSins_dbolkpSebumLevel]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 nvarchar(500),
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 nvarchar(100),
    @c12 nvarchar(100)
as
begin
	insert into [dbo].[lkpSebumLevel] (
		[SebumLevelID],
		[SebumLevelSortOrder],
		[SebumLevelDescription],
		[SebumLevelDescriptionShort],
		[SebumLevelDetail],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[DescriptionResourceKey],
		[DetailResourceKey]
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
		@c12	)
end
GO
