/* CreateDate: 03/17/2022 11:57:04.297 , ModifyDate: 03/17/2022 11:57:04.297 */
GO
create procedure [sp_MSins_bief_dds_DBVersion]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 datetime
as
begin
	insert into [bief_dds].[_DBVersion] (
		[DBVersionMajor],
		[DBVersionMinor],
		[DBVersionBuild],
		[DBVersionRevision],
		[RowUpdateDate]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5	)
end
GO
