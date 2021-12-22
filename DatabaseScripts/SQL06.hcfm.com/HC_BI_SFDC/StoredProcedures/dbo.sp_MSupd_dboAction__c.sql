/* CreateDate: 10/04/2019 14:09:30.163 , ModifyDate: 10/04/2019 14:09:30.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dboAction__c]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nchar(10) = NULL,
		@c4 bit = NULL,
		@c5 nvarchar(18) = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(18) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(50) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[Action__c] set
		[Action__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Action__c] end,
		[ONC_ActionCode] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ONC_ActionCode] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [IsActiveFlag] end,
		[CreatedById] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastModifiedDate] end,
		[ONC_ActionCodeDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ONC_ActionCodeDescription] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[Action__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
