/* CreateDate: 11/17/2020 12:12:00.360 , ModifyDate: 11/17/2020 12:12:00.360 */
GO
create procedure [dbo].[sp_MSupd_dboAccount]
		@c1 nvarchar(18) = NULL,
		@c2 nvarchar(18) = NULL,
		@c3 nvarchar(18) = NULL,
		@c4 nvarchar(80) = NULL,
		@c5 nvarchar(80) = NULL,
		@c6 nvarchar(80) = NULL,
		@c7 bit = NULL,
		@c8 nvarchar(18) = NULL,
		@c9 datetime = NULL,
		@c10 nvarchar(18) = NULL,
		@c11 datetime = NULL,
		@pkc1 nvarchar(18) = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[Account] set
		[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
		[PersonContactId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [PersonContactId] end,
		[RecordTypeId] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RecordTypeId] end,
		[AccountNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AccountNumber] end,
		[FirstName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FirstName] end,
		[LastName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastName] end,
		[IsDeleted] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Account]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[Account] set
		[PersonContactId] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [PersonContactId] end,
		[RecordTypeId] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [RecordTypeId] end,
		[AccountNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AccountNumber] end,
		[FirstName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [FirstName] end,
		[LastName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [LastName] end,
		[IsDeleted] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Account]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
