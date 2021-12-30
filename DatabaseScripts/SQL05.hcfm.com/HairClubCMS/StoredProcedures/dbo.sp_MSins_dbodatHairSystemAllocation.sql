/* CreateDate: 05/05/2020 17:42:50.003 , ModifyDate: 05/05/2020 17:42:50.003 */
GO
create procedure [sp_MSins_dbodatHairSystemAllocation]
    @c1 uniqueidentifier,
    @c2 datetime,
    @c3 datetime,
    @c4 nvarchar(25),
    @c5 datetime,
    @c6 nvarchar(25)
as
begin
	insert into [dbo].[datHairSystemAllocation] (
		[HairSystemAllocationGUID],
		[HairSystemAllocationDate],
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
		default	)
end
GO
