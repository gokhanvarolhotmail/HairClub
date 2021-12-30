/* CreateDate: 05/05/2020 17:42:48.543 , ModifyDate: 05/05/2020 17:42:48.543 */
GO
create procedure [sp_MSins_dbodatAppointmentEmployee]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 datetime,
    @c5 nvarchar(25),
    @c6 datetime,
    @c7 nvarchar(25)
as
begin
	insert into [dbo].[datAppointmentEmployee] (
		[AppointmentEmployeeGUID],
		[AppointmentGUID],
		[EmployeeGUID],
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
		default	)
end
GO
