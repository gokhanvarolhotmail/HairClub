create procedure [sp_MSupd_dboSaleTypeCode__c]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 int = NULL,
		@c5 bit = NULL,
		@c6 nvarchar(18) = NULL,
		@c7 datetime = NULL,
		@c8 nvarchar(18) = NULL,
		@c9 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[SaleTypeCode__c] set
		[SaleTypeCode__c] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [SaleTypeCode__c] end,
		[SaleTypeDescription__c] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [SaleTypeDescription__c] end,
		[SortOrder] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [SortOrder] end,
		[IsActiveFlag] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [IsActiveFlag] end,
		[CreatedById] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreatedById] end,
		[CreatedDate] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreatedDate] end,
		[LastModifiedById] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastModifiedById] end,
		[LastModifiedDate] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastModifiedDate] end
	where [Id] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[Id] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[SaleTypeCode__c]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
