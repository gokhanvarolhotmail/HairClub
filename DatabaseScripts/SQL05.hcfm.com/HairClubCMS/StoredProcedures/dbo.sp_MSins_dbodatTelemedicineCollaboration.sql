/* CreateDate: 05/05/2020 17:42:53.553 , ModifyDate: 05/05/2020 17:42:53.553 */
GO
create procedure [sp_MSins_dbodatTelemedicineCollaboration]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 datetime,
    @c4 datetime,
    @c5 text,
    @c6 text,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 datetime,
    @c10 nvarchar(25)
as
begin
	insert into [dbo].[datTelemedicineCollaboration] (
		[TelemedicineCollaborationGUID],
		[AppointmentGUID],
		[StartDate],
		[EndDate],
		[Expectations],
		[MedicalHistory],
		[CreateUser],
		[CreateDateTime],
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
		@c10	)
end
GO
