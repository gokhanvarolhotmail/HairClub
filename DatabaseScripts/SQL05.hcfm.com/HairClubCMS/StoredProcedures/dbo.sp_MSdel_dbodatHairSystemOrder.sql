/* CreateDate: 10/19/2020 08:36:30.660 , ModifyDate: 10/19/2020 08:36:30.660 */
GO
create procedure [dbo].[sp_MSdel_dbodatHairSystemOrder]     @pkc1 uniqueidentifier
as
begin   	declare @primarykey_text nvarchar(100) = '' 	delete [dbo].[datHairSystemOrder]
	where [HairSystemOrderGUID] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemOrder]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end    --
GO
