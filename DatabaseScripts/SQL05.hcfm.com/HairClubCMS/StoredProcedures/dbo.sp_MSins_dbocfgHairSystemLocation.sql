/* CreateDate: 05/05/2020 17:42:43.480 , ModifyDate: 05/05/2020 17:42:43.480 */
GO
create procedure [sp_MSins_dbocfgHairSystemLocation]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 nvarchar(50),
    @c7 int,
    @c8 bit,
    @c9 datetime,
    @c10 nvarchar(25),
    @c11 datetime,
    @c12 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemLocation] (
		[HairSystemLocationID],
		[CenterID],
		[CabinetNumber],
		[DrawerNumber],
		[BinNumber],
		[NonstandardDescription],
		[MaximumQuantityPerLocation],
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
