/* CreateDate: 05/05/2020 17:42:39.630 , ModifyDate: 05/05/2020 17:42:39.630 */
GO
create procedure [sp_MSins_dbocfgCenterManagementArea]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 uniqueidentifier,
    @c6 bit,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25)
as
begin
	insert into [dbo].[cfgCenterManagementArea] (
		[CenterManagementAreaID],
		[CenterManagementAreaSortOrder],
		[CenterManagementAreaDescription],
		[CenterManagementAreaDescriptionShort],
		[OperationsManagerGUID],
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
		default	)
end
GO
