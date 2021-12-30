/* CreateDate: 10/04/2019 14:09:30.397 , ModifyDate: 10/04/2019 14:09:30.397 */
GO
create procedure [sp_MSupd_dboPhone__c]
		@c1 nvarchar(18) = NULL,
		@c2 nvarchar(18) = NULL,
		@c3 nchar(10) = NULL,
		@c4 nchar(10) = NULL,
		@c5 nvarchar(80) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 bit = NULL,
		@c8 bit = NULL,
		@c9 bit = NULL,
		@c10 bit = NULL,
		@c11 datetime = NULL,
		@c12 bit = NULL,
		@c13 bit = NULL,
		@c14 int = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 bit = NULL,
		@c17 nvarchar(50) = NULL,
		@c18 bit = NULL,
		@c19 nvarchar(18) = NULL,
		@c20 datetime = NULL,
		@c21 nvarchar(18) = NULL,
		@c22 datetime = NULL,
		@pkc1 nvarchar(18) = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[Phone__c] set
		[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
		[Lead__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Lead__c] end,
		[ContactPhoneID__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ContactPhoneID__c] end,
		[OncContactID__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [OncContactID__c] end,
		[Name] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Name] end,
		[PhoneAbr__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PhoneAbr__c] end,
		[DoNotCall__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [DoNotCall__c] end,
		[DoNotText__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [DoNotText__c] end,
		[DNCFlag__c] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DNCFlag__c] end,
		[EBRDNC__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [EBRDNC__c] end,
		[EBRDNCDate__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EBRDNCDate__c] end,
		[Wireless__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Wireless__c] end,
		[Primary__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Primary__c] end,
		[SortOrder__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [SortOrder__c] end,
		[Status__c] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Status__c] end,
		[ValidFlag__c] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ValidFlag__c] end,
		[Type__c] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Type__c] end,
		[IsDeleted] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Phone__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[Phone__c] set
		[Lead__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Lead__c] end,
		[ContactPhoneID__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ContactPhoneID__c] end,
		[OncContactID__c] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [OncContactID__c] end,
		[Name] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Name] end,
		[PhoneAbr__c] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PhoneAbr__c] end,
		[DoNotCall__c] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [DoNotCall__c] end,
		[DoNotText__c] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [DoNotText__c] end,
		[DNCFlag__c] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [DNCFlag__c] end,
		[EBRDNC__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [EBRDNC__c] end,
		[EBRDNCDate__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EBRDNCDate__c] end,
		[Wireless__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Wireless__c] end,
		[Primary__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [Primary__c] end,
		[SortOrder__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [SortOrder__c] end,
		[Status__c] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Status__c] end,
		[ValidFlag__c] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [ValidFlag__c] end,
		[Type__c] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Type__c] end,
		[IsDeleted] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsDeleted] end,
		[CreatedById] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Phone__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
