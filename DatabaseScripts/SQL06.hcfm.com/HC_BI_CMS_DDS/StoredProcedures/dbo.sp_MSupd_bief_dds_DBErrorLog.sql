/* CreateDate: 03/17/2022 11:57:03.620 , ModifyDate: 03/17/2022 11:57:03.620 */
GO
create procedure [sp_MSupd_bief_dds_DBErrorLog]
		@c1 int = NULL,
		@c2 datetime = NULL,
		@c3 nvarchar(128) = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 nvarchar(126) = NULL,
		@c8 int = NULL,
		@c9 nvarchar(4000) = NULL,
		@c10 nvarchar(1000) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bief_dds].[_DBErrorLog] set
		[ErrorTime] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ErrorTime] end,
		[UserName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [UserName] end,
		[ErrorNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ErrorNumber] end,
		[ErrorSeverity] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ErrorSeverity] end,
		[ErrorState] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ErrorState] end,
		[ErrorProcedure] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ErrorProcedure] end,
		[ErrorLine] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ErrorLine] end,
		[ErrorMessage] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ErrorMessage] end,
		[ErrorDetails] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ErrorDetails] end
	where [DBErrorLogID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DBErrorLogID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBErrorLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
