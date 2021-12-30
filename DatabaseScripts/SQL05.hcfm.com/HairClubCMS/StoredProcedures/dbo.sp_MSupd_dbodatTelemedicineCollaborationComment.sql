/* CreateDate: 05/05/2020 17:42:53.610 , ModifyDate: 05/05/2020 17:42:53.610 */
GO
create procedure [sp_MSupd_dbodatTelemedicineCollaborationComment]
		@c1 uniqueidentifier = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 nvarchar(max) = NULL,
		@c5 nvarchar(25) = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datTelemedicineCollaborationComment] set
		[TelemedicineCollaborationCommentGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [TelemedicineCollaborationCommentGUID] end,
		[TelemedicineCollaborationGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TelemedicineCollaborationGUID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeGUID] end,
		[Details] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Details] end,
		[CreateUser] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateUser] end,
		[CreateDateTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDateTime] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end
	where [TelemedicineCollaborationCommentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TelemedicineCollaborationCommentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTelemedicineCollaborationComment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datTelemedicineCollaborationComment] set
		[TelemedicineCollaborationGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TelemedicineCollaborationGUID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeGUID] end,
		[Details] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Details] end,
		[CreateUser] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreateUser] end,
		[CreateDateTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDateTime] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdateUser] end
	where [TelemedicineCollaborationCommentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TelemedicineCollaborationCommentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datTelemedicineCollaborationComment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
