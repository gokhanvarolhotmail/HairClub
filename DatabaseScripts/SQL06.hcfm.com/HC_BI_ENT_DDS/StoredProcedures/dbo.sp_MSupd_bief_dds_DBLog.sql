/* CreateDate: 01/08/2021 15:21:53.197 , ModifyDate: 01/08/2021 15:21:53.197 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bief_dds_DBLog]
		@c1 int = NULL,
		@c2 datetime = NULL,
		@c3 nvarchar(128) = NULL,
		@c4 nvarchar(128) = NULL,
		@c5 nvarchar(128) = NULL,
		@c6 nvarchar(128) = NULL,
		@c7 nvarchar(max) = NULL,
		@c8 xml = NULL,
		@pkc1 int = NULL,
		@bitmap binary(1)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bief_dds].[_DBLog] set
		[PostTime] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [PostTime] end,
		[DatabaseUser] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [DatabaseUser] end,
		[Event] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Event] end,
		[Schema] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Schema] end,
		[Object] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Object] end,
		[TSQL] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [TSQL] end,
		[XmlEvent] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else convert(xml,[XmlEvent]) end
	where [DBLogID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[DBLogID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[_DBLog]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
