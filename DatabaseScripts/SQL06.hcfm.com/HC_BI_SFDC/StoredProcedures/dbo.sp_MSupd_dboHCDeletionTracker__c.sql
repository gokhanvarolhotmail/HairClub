/* CreateDate: 10/04/2019 14:09:30.330 , ModifyDate: 10/04/2019 14:09:30.330 */
GO
create procedure [sp_MSupd_dboHCDeletionTracker__c]
		@c1 nvarchar(18) = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 nvarchar(18) = NULL,
		@c4 bit = NULL,
		@c5 nvarchar(80) = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(18) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(18) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(18) = NULL,
		@c12 nvarchar(18) = NULL,
		@c13 nvarchar(18) = NULL,
		@c14 bit = NULL,
		@c15 bit = NULL,
		@c16 bit = NULL,
		@c17 nvarchar(2000) = NULL,
		@c18 datetime = NULL,
		@pkc1 nvarchar(18) = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[HCDeletionTracker__c] set
		[Id] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [Id] end,
		[SessionID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SessionID] end,
		[OwnerId] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [OwnerId] end,
		[IsDeleted] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsDeleted] end,
		[Name] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Name] end,
		[CreatedDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreatedDate] end,
		[CreatedById] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreatedById] end,
		[LastModifiedDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastModifiedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastModifiedById] end,
		[ObjectName__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ObjectName__c] end,
		[DeletedId__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [DeletedId__c] end,
		[DeletedById__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DeletedById__c] end,
		[MasterRecordId__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [MasterRecordId__c] end,
		[ToBeProcessed__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ToBeProcessed__c] end,
		[IsProcessed] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsProcessed] end,
		[IsError] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsError] end,
		[ErrorMessage] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ErrorMessage] end,
		[LastProcessedDate__c] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastProcessedDate__c] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[HCDeletionTracker__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[HCDeletionTracker__c] set
		[SessionID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SessionID] end,
		[OwnerId] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [OwnerId] end,
		[IsDeleted] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsDeleted] end,
		[Name] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Name] end,
		[CreatedDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreatedDate] end,
		[CreatedById] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreatedById] end,
		[LastModifiedDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastModifiedDate] end,
		[LastModifiedById] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastModifiedById] end,
		[ObjectName__c] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ObjectName__c] end,
		[DeletedId__c] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [DeletedId__c] end,
		[DeletedById__c] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DeletedById__c] end,
		[MasterRecordId__c] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [MasterRecordId__c] end,
		[ToBeProcessed__c] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ToBeProcessed__c] end,
		[IsProcessed] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsProcessed] end,
		[IsError] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsError] end,
		[ErrorMessage] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ErrorMessage] end,
		[LastProcessedDate__c] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [LastProcessedDate__c] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[HCDeletionTracker__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
