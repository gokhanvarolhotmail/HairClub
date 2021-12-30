/* CreateDate: 10/03/2019 23:03:42.460 , ModifyDate: 10/03/2019 23:03:42.460 */
GO
create procedure [dbo].[sp_MSdel_bi_cms_ddsFactSalesTransaction]
		@pkc1 int,
		@pkc2 int,
		@pkc3 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bi_cms_dds].[FactSalesTransaction]
	where [OrderDateKey] = @pkc1
  and [SalesOrderKey] = @pkc2
  and [SalesOrderDetailKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[OrderDateKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[SalesOrderKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[SalesOrderDetailKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[FactSalesTransaction]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
