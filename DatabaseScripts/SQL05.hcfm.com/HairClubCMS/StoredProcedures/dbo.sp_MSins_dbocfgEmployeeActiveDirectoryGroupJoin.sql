/* CreateDate: 05/05/2020 17:42:41.637 , ModifyDate: 05/05/2020 17:42:41.637 */
GO
create procedure [sp_MSins_dbocfgEmployeeActiveDirectoryGroupJoin]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 datetime,
    @c4 nvarchar(25),
    @c5 datetime,
    @c6 nvarchar(25)
as
begin
	insert into [dbo].[cfgEmployeeActiveDirectoryGroupJoin] (
		[EmployeeGUID],
		[ActiveDirectoryGroupID],
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
