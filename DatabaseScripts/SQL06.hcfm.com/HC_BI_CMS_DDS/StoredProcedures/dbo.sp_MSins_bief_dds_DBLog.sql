/* CreateDate: 03/17/2022 11:57:03.660 , ModifyDate: 03/17/2022 11:57:03.660 */
GO
create procedure [sp_MSins_bief_dds_DBLog]
    @c1 int,
    @c2 datetime,
    @c3 nvarchar(128),
    @c4 nvarchar(128),
    @c5 nvarchar(128),
    @c6 nvarchar(128),
    @c7 nvarchar(max),
    @c8 xml
as
begin
	insert into [bief_dds].[_DBLog] (
		[DBLogID],
		[PostTime],
		[DatabaseUser],
		[Event],
		[Schema],
		[Object],
		[TSQL],
		[XmlEvent]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8	)
end
GO
