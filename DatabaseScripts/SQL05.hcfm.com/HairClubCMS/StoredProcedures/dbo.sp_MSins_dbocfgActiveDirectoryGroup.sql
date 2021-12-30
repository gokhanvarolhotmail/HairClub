/* CreateDate: 05/05/2020 17:42:38.307 , ModifyDate: 05/05/2020 17:42:38.307 */
GO
create procedure [sp_MSins_dbocfgActiveDirectoryGroup]
    @c1 int,
    @c2 nvarchar(100),
    @c3 datetime,
    @c4 nvarchar(25),
    @c5 datetime,
    @c6 nvarchar(25)
as
begin
	insert into [dbo].[cfgActiveDirectoryGroup] (
		[ActiveDirectoryGroupID],
		[ActiveDirectoryGroup],
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
