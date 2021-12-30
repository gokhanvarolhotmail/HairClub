/* CreateDate: 05/05/2020 17:42:51.350 , ModifyDate: 05/05/2020 17:42:51.350 */
GO
create procedure [sp_MSins_dbodatNotesClient]
    @c1 uniqueidentifier,
    @c2 uniqueidentifier,
    @c3 uniqueidentifier,
    @c4 uniqueidentifier,
    @c5 uniqueidentifier,
    @c6 uniqueidentifier,
    @c7 int,
    @c8 datetime,
    @c9 nvarchar(4000),
    @c10 datetime,
    @c11 nvarchar(25),
    @c12 datetime,
    @c13 nvarchar(25),
    @c14 uniqueidentifier,
    @c15 int,
    @c16 bit,
    @c17 int
as
begin
	insert into [dbo].[datNotesClient] (
		[NotesClientGUID],
		[ClientGUID],
		[EmployeeGUID],
		[AppointmentGUID],
		[SalesOrderGUID],
		[ClientMembershipGUID],
		[NoteTypeID],
		[NotesClientDate],
		[NotesClient],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[HairSystemOrderGUID],
		[NoteSubTypeID],
		[IsFlagged],
		[ScorecardCategoryID]
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
		@c15,
		@c16,
		@c17	)
end
GO
