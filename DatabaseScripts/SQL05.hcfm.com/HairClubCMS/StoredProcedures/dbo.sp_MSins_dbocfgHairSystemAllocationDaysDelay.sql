/* CreateDate: 05/05/2020 17:42:41.733 , ModifyDate: 05/05/2020 17:42:41.733 */
GO
create procedure [sp_MSins_dbocfgHairSystemAllocationDaysDelay]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 varchar(10),
    @c5 int,
    @c6 int,
    @c7 bit,
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 datetime,
    @c11 nvarchar(25)
as
begin
	insert into [dbo].[cfgHairSystemAllocationDaysDelay] (
		[HairSystemAllocationDaysDelayID],
		[HairSystemAllocationDaysDelaySortOrder],
		[HairSystemAllocationDaysDelayDescription],
		[HairSystemAllocationDaysDelayDescriptionShort],
		[MinimumValue],
		[MaximumValue],
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
		default	)
end
GO
