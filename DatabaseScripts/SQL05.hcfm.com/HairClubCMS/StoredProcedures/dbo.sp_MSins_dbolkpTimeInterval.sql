/* CreateDate: 05/05/2020 17:42:55.330 , ModifyDate: 05/05/2020 17:42:55.330 */
GO
create procedure [sp_MSins_dbolkpTimeInterval]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 bit,
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25)
as
begin
	insert into [dbo].[lkpTimeInterval] (
		[TimeIntervalID],
		[TimeIntervalSortOrder],
		[TimeIntervalDescription],
		[TimeIntervalDescriptionShort],
		[MaximumValue],
		[MinimumValue],
		[Interval],
		[TimeUnitID],
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
		@c13,
		default	)
end
GO
