/* CreateDate: 05/05/2020 17:42:46.013 , ModifyDate: 05/05/2020 17:42:46.013 */
GO
create procedure [sp_MSins_dbolkpHairSystemColorPercentage]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 int,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 decimal(3,0)
as
begin
	insert into [dbo].[lkpHairSystemColorPercentage] (
		[HairSystemColorPercentageID],
		[HairSystemColorPercentageSortOrder],
		[HairSystemColorPercentageDescription],
		[HairSystemColorPercentageDescriptionShort],
		[HairSystemColorPercentageValue],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[HairSystemColorPercentageValueDecimal]
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
