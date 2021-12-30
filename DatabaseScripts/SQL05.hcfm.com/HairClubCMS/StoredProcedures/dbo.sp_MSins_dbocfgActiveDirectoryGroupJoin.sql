/* CreateDate: 05/05/2020 17:42:38.437 , ModifyDate: 05/05/2020 17:42:38.437 */
GO
create procedure [sp_MSins_dbocfgActiveDirectoryGroupJoin]
    @c1 int,
    @c2 int,
    @c3 datetime,
    @c4 nvarchar(25),
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 int
as
begin
	insert into [dbo].[cfgActiveDirectoryGroupJoin] (
		[ActiveDirectoryGroupID],
		[EmployeePositionID],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ActiveDirectoryGroupJoinID]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		default,
		@c7	)
end
GO
