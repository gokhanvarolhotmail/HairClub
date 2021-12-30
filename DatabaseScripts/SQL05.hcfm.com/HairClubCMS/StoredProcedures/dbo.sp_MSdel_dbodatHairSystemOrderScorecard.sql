/* CreateDate: 03/01/2021 17:56:32.957 , ModifyDate: 03/01/2021 17:56:32.957 */
GO
create procedure [dbo].[sp_MSdel_dbodatHairSystemOrderScorecard]     @pkc1 int
as
begin   	declare @primarykey_text nvarchar(100) = '' 	delete [dbo].[datHairSystemOrderScorecard]
	where [HairSystemOrderScorecardID] = @pkc1 if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[HairSystemOrderScorecardID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datHairSystemOrderScorecard]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End end    --
GO
