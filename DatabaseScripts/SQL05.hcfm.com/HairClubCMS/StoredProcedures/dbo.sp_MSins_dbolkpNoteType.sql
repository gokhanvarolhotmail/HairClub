/* CreateDate: 05/05/2020 17:42:51.250 , ModifyDate: 05/05/2020 17:42:51.250 */
GO
create procedure [sp_MSins_dbolkpNoteType]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 bit,
    @c6 datetime,
    @c7 nvarchar(25),
    @c8 datetime,
    @c9 nvarchar(25),
    @c10 nvarchar(100),
    @c11 bit
as
begin
	insert into [dbo].[lkpNoteType] (
		[NoteTypeID],
		[NoteTypeSortOrder],
		[NoteTypeDescription],
		[NoteTypeDescriptionShort],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[DescriptionResourceKey],
		[IsTypeAllowedForManualEntry]
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
		default,
		@c10,
		@c11	)
end
GO
