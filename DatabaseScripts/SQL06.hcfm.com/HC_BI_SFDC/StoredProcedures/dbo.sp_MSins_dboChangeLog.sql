/* CreateDate: 10/04/2019 14:09:30.263 , ModifyDate: 10/04/2019 14:09:30.263 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSins_dboChangeLog]
    @c1 int,
    @c2 uniqueidentifier,
    @c3 nvarchar(80),
    @c4 nvarchar(50),
    @c5 nvarchar(80),
    @c6 nvarchar(50),
    @c7 nvarchar(50),
    @c8 datetime,
    @c9 nvarchar(50),
    @c10 datetime,
    @c11 nvarchar(50)
as
begin
	insert into [dbo].[ChangeLog] (
		[ChangeLogID],
		[SessionID],
		[ObjectName],
		[ObjectKey],
		[ColumnName],
		[OldValue],
		[NewValue],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser]
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
		@c11	)
end
GO
