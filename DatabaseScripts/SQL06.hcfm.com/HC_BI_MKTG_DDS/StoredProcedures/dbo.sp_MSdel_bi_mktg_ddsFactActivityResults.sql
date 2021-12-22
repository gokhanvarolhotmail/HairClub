/* CreateDate: 09/03/2021 09:37:06.860 , ModifyDate: 09/03/2021 09:37:06.860 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSdel_bi_mktg_ddsFactActivityResults]
		@pkc1 int,
		@pkc2 int,
		@pkc3 int
as
begin
	declare @primarykey_text nvarchar(100) = ''
	delete [bi_mktg_dds].[FactActivityResults]
	where [ActivityKey] = @pkc1
  and [ActivityDateKey] = @pkc2
  and [ActivityTimeKey] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActivityKey] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityDateKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[ActivityTimeKey] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[FactActivityResults]', @param2=@primarykey_text, @param3=13234
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
