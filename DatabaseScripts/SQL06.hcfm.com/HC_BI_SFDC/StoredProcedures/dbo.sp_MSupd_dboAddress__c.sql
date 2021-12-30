/* CreateDate: 10/04/2019 14:09:30.200 , ModifyDate: 10/04/2019 14:09:30.200 */
GO
create procedure [sp_MSupd_dboAddress__c]
		@c1 nvarchar(18) = NULL,
		@c2 nvarchar(18) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(10) = NULL,
		@c5 nvarchar(250) = NULL,
		@c6 nvarchar(250) = NULL,
		@c7 nvarchar(250) = NULL,
		@c8 nvarchar(250) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 bit = NULL,
		@c14 bit = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 bit = NULL,
		@c17 nvarchar(18) = NULL,
		@c18 datetime = NULL,
		@c19 nvarchar(18) = NULL,
		@c20 datetime = NULL,
		@pkc1 nvarchar(18) = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[Address__c] set
		[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
		[Lead__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Lead__c] end,
		[OncContactAddressID__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [OncContactAddressID__c] end,
		[OncContactID__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [OncContactID__c] end,
		[Street__c] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Street__c] end,
		[Street2__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Street2__c] end,
		[Street3__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Street3__c] end,
		[Street4__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Street4__c] end,
		[City__c] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [City__c] end,
		[State__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [State__c] end,
		[Zip__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Zip__c] end,
		[Country__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Country__c] end,
		[DoNotMail__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [DoNotMail__c] end,
		[Primary__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Primary__c] end,
		[Status__c] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Status__c] end,
		[IsDeleted] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Address__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[Address__c] set
		[Lead__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Lead__c] end,
		[OncContactAddressID__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [OncContactAddressID__c] end,
		[OncContactID__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [OncContactID__c] end,
		[Street__c] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Street__c] end,
		[Street2__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Street2__c] end,
		[Street3__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Street3__c] end,
		[Street4__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Street4__c] end,
		[City__c] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [City__c] end,
		[State__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [State__c] end,
		[Zip__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Zip__c] end,
		[Country__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Country__c] end,
		[DoNotMail__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [DoNotMail__c] end,
		[Primary__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [Primary__c] end,
		[Status__c] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Status__c] end,
		[IsDeleted] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Address__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
