/* CreateDate: 03/15/2021 09:16:05.630 , ModifyDate: 03/15/2021 09:16:05.630 */
GO
create procedure [sp_MSdel_dbolkpRegion]     @pkc1 int
as
begin   	declare @primarykey_text nvarchar(100) = '' 	delete [dbo].[lkpRegion]
	where [RegionID] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[RegionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpRegion]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end    --
GO
