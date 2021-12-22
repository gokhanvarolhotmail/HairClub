create procedure [sp_MSupd_dboUser]
		@c1 nvarchar(18) = NULL,
		@c2 nvarchar(40) = NULL,
		@c3 nvarchar(80) = NULL,
		@c4 nvarchar(102) = NULL,
		@c5 nvarchar(80) = NULL,
		@c6 nvarchar(20) = NULL,
		@c7 nvarchar(8) = NULL,
		@c8 nvarchar(80) = NULL,
		@c9 nvarchar(80) = NULL,
		@c10 nvarchar(80) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 bit = NULL,
		@c13 nvarchar(18) = NULL,
		@c14 datetime = NULL,
		@c15 nvarchar(18) = NULL,
		@c16 datetime = NULL,
		@pkc1 nvarchar(18) = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[User] set
		[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
		[FirstName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [FirstName] end,
		[LastName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LastName] end,
		[Name] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Name] end,
		[Username] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Username] end,
		[UserCode__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [UserCode__c] end,
		[Alias] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Alias] end,
		[Title] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Title] end,
		[Department] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Department] end,
		[CompanyName] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CompanyName] end,
		[Team] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Team] end,
		[IsDeleted] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[User]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[User] set
		[FirstName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [FirstName] end,
		[LastName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [LastName] end,
		[Name] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Name] end,
		[Username] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Username] end,
		[UserCode__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [UserCode__c] end,
		[Alias] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Alias] end,
		[Title] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Title] end,
		[Department] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Department] end,
		[CompanyName] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CompanyName] end,
		[Team] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Team] end,
		[IsDeleted] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[User]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
