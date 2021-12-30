/* CreateDate: 10/04/2019 14:09:30.103 , ModifyDate: 10/04/2019 14:09:30.103 */
GO
create procedure [sp_MSupd_dbo_DataFlow]
		@c1 int = NULL,
		@c2 varchar(250) = NULL,
		@c3 varchar(50) = NULL,
		@c4 datetime = NULL,
		@c5 datetime = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[_DataFlow] set
		[TableName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [TableName] end,
		[Status] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Status] end,
		[LSET] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [LSET] end,
		[CET] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CET] end
	where [DataFlowKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DataFlowKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[_DataFlow]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
