/* CreateDate: 05/05/2020 17:42:49.860 , ModifyDate: 05/05/2020 17:42:49.860 */
GO
create procedure [sp_MSins_dbodatEmployeeTimeClock]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 datetime,
    @c4 datetime,
    @c5 datetime,
    @c6 datetime,
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 datetime,
    @c10 nvarchar(25)
as
begin
	insert into [dbo].[datEmployeeTimeClock] (
		[EmployeeTimeClockGUID],
		[EmployeeGUID],
		[CheckInDate],
		[CheckinTime],
		[CheckOutDate],
		[CheckOutTime],
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
