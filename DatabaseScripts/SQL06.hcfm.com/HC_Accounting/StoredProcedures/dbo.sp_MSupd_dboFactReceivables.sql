/* CreateDate: 10/03/2019 22:32:12.533 , ModifyDate: 10/03/2019 22:32:12.533 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_dboFactReceivables]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 float = NULL,
		@c6 money = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[FactReceivables] set
		[CenterKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterKey] end,
		[DateKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [DateKey] end,
		[ClientKey] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientKey] end,
		[Balance] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Balance] end,
		[PrePaid] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PrePaid] end
	where [ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FactReceivables]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
