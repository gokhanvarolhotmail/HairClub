/* CreateDate: 10/03/2019 23:03:39.603 , ModifyDate: 10/03/2019 23:03:39.603 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
