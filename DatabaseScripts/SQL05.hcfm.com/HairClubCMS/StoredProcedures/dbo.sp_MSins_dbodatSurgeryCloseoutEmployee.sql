/* CreateDate: 05/05/2020 17:42:52.000 , ModifyDate: 05/05/2020 17:42:52.000 */
GO
create procedure [sp_MSins_dbodatSurgeryCloseoutEmployee]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 int,
    @c5 int,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25)
as
begin
	insert into [dbo].[datSurgeryCloseoutEmployee] (
		[SurgeryCloseoutEmployeeGUID],
		[AppointmentGUID],
		[EmployeeGUID],
		[CutCount],
		[PlaceCount],
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
		default	)
end
GO
