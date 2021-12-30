/* CreateDate: 05/05/2020 17:42:37.733 , ModifyDate: 05/05/2020 17:42:37.733 */
GO
create procedure [sp_MSupd_dbocfgVendor]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 nvarchar(100) = NULL,
		@c5 nvarchar(10) = NULL,
		@c6 nvarchar(100) = NULL,
		@c7 nvarchar(100) = NULL,
		@c8 nvarchar(100) = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 nvarchar(25) = NULL,
		@c11 int = NULL,
		@c12 bit = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 nvarchar(50) = NULL,
		@c18 nvarchar(20) = NULL,
		@c19 nvarchar(20) = NULL,
		@c20 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[cfgVendor] set
		[VendorTypeID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [VendorTypeID] end,
		[VendorSortOrder] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [VendorSortOrder] end,
		[VendorDescription] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [VendorDescription] end,
		[VendorDescriptionShort] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [VendorDescriptionShort] end,
		[VendorAddress1] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [VendorAddress1] end,
		[VendorAddress2] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [VendorAddress2] end,
		[VendorAddress3] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [VendorAddress3] end,
		[VendorPhone] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [VendorPhone] end,
		[VendorFax] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [VendorFax] end,
		[VendorContractCounter] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [VendorContractCounter] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdateUser] end,
		[FactoryColor] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [FactoryColor] end,
		[GPVendorID] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [GPVendorID] end,
		[GPVendorDescription] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [GPVendorDescription] end,
		[VendorExportFileTypeID] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [VendorExportFileTypeID] end
	where [VendorID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[VendorID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgVendor]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
