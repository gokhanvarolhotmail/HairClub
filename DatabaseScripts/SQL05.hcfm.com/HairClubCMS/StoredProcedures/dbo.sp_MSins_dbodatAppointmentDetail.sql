/* CreateDate: 05/05/2020 17:42:48.493 , ModifyDate: 05/05/2020 17:42:48.493 */
GO
create procedure [sp_MSins_dbodatAppointmentDetail]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 int,
    @c4 int,
    @c5 datetime,
    @c6 nvarchar(25),
    @c7 datetime,
    @c8 nvarchar(25),
    @c9 int,
    @c10 money
as
begin
	insert into [dbo].[datAppointmentDetail] (
		[AppointmentDetailGUID],
		[AppointmentGUID],
		[SalesCodeID],
		[AppointmentDetailDuration],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[Quantity],
		[Price]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		default,
		@c9,
		@c10	)
end
GO
