/* CreateDate: 05/05/2020 17:42:51.357 , ModifyDate: 05/05/2020 17:42:51.357 */
GO
create procedure [sp_MSupd_dbodatNotesClient]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 uniqueidentifier = NULL,
		@c7 int = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(4000) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@c14 uniqueidentifier = NULL,
		@c15 int = NULL,
		@c16 bit = NULL,
		@c17 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datNotesClient] set
		[NotesClientGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [NotesClientGUID] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeGUID] end,
		[AppointmentGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AppointmentGUID] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalesOrderGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientMembershipGUID] end,
		[NoteTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [NoteTypeID] end,
		[NotesClientDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [NotesClientDate] end,
		[NotesClient] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [NotesClient] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[HairSystemOrderGUID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [HairSystemOrderGUID] end,
		[NoteSubTypeID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [NoteSubTypeID] end,
		[IsFlagged] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsFlagged] end,
		[ScorecardCategoryID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ScorecardCategoryID] end
	where [NotesClientGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[NotesClientGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datNotesClient]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datNotesClient] set
		[ClientGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ClientGUID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeGUID] end,
		[AppointmentGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AppointmentGUID] end,
		[SalesOrderGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalesOrderGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientMembershipGUID] end,
		[NoteTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [NoteTypeID] end,
		[NotesClientDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [NotesClientDate] end,
		[NotesClient] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [NotesClient] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end,
		[HairSystemOrderGUID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [HairSystemOrderGUID] end,
		[NoteSubTypeID] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [NoteSubTypeID] end,
		[IsFlagged] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsFlagged] end,
		[ScorecardCategoryID] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ScorecardCategoryID] end
	where [NotesClientGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[NotesClientGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datNotesClient]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
