/* CreateDate: 05/05/2020 17:42:44.950 , ModifyDate: 05/05/2020 17:42:44.950 */
GO
create procedure [sp_MSins_dbocfgScheduleTemplate]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 int,
    @c4 uniqueidentifier,
    @c5 time(0),
    @c6 time(0),
    @c7 int,
    @c8 int,
    @c9 bit,
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25)
as
begin
	insert into [dbo].[cfgScheduleTemplate] (
		[ScheduleTemplateGUID],
		[ScheduleTemplateDayOfWeek],
		[CenterID],
		[EmployeeGUID],
		[StartTime],
		[EndTime],
		[ScheduleTypeID],
		[ScheduleCalendarTypeID],
		[IsActiveScheduleFlag],
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
