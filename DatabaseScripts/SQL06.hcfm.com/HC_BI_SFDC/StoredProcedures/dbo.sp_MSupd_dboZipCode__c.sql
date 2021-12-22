create procedure [dbo].[sp_MSupd_dboZipCode__c]
		@c1 nvarchar(18) = NULL,
		@c2 nvarchar(255) = NULL,
		@c3 nchar(4) = NULL,
		@c4 nvarchar(255) = NULL,
		@c5 nvarchar(80) = NULL,
		@c6 nchar(4) = NULL,
		@c7 nvarchar(255) = NULL,
		@c8 nvarchar(255) = NULL,
		@c9 bit = NULL,
		@c10 nvarchar(18) = NULL,
		@c11 datetime = NULL,
		@c12 nvarchar(18) = NULL,
		@c13 datetime = NULL,
		@pkc1 nvarchar(18) = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[ZipCode__c] set
		[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
		[City__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [City__c] end,
		[State__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [State__c] end,
		[County__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [County__c] end,
		[Name] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Name] end,
		[Country__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Country__c] end,
		[DMA__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [DMA__c] end,
		[Timezone__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Timezone__c] end,
		[IsDeleted] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ZipCode__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[ZipCode__c] set
		[City__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [City__c] end,
		[State__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [State__c] end,
		[County__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [County__c] end,
		[Name] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Name] end,
		[Country__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Country__c] end,
		[DMA__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [DMA__c] end,
		[Timezone__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Timezone__c] end,
		[IsDeleted] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[ZipCode__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
