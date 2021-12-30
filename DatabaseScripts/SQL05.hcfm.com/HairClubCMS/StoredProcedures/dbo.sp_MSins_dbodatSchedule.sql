/* CreateDate: 05/05/2020 17:42:51.950 , ModifyDate: 05/05/2020 17:42:51.950 */
GO
create procedure [sp_MSins_dbodatSchedule]
    @c1 uniqueidentifier,
    @c2 int,
    @c3 uniqueidentifier,
    @c4 date,
    @c5 time(0),
    @c6 time(0),
    @c7 nvarchar(500),
    @c8 uniqueidentifier,
    @c9 varchar(1024),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25),
    @c14 int,
    @c15 int
as
begin
	insert into [dbo].[datSchedule] (
		[ScheduleGUID],
		[CenterID],
		[EmployeeGUID],
		[ScheduleDate],
		[StartTime],
		[EndTime],
		[ScheduleSubject],
		[ParentScheduleGUID],
		[RecurrenceRule],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ScheduleTypeID],
		[ScheduleCalendarTypeID]
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
		default,
		@c14,
		@c15	)
end
GO
