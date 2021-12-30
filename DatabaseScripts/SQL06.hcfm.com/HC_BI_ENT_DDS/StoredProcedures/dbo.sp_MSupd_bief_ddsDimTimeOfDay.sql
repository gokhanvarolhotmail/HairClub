/* CreateDate: 01/08/2021 15:21:54.087 , ModifyDate: 01/08/2021 15:21:54.087 */
GO
create procedure [sp_MSupd_bief_ddsDimTimeOfDay]
		@c1 int = NULL,
		@c2 varchar(12) = NULL,
		@c3 varchar(8) = NULL,
		@c4 smallint = NULL,
		@c5 varchar(10) = NULL,
		@c6 smallint = NULL,
		@c7 smallint = NULL,
		@c8 varchar(20) = NULL,
		@c9 smallint = NULL,
		@c10 smallint = NULL,
		@c11 char(2) = NULL,
		@c12 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bief_dds].[DimTimeOfDay] set
		[Time] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [Time] end,
		[Time24] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Time24] end,
		[Hour] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [Hour] end,
		[HourName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [HourName] end,
		[Minute] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Minute] end,
		[MinuteKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [MinuteKey] end,
		[MinuteName] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [MinuteName] end,
		[Second] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [Second] end,
		[Hour24] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Hour24] end,
		[AM] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AM] end,
		[msrepl_tran_version] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [msrepl_tran_version] end
	where [TimeOfDayKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[TimeOfDayKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bief_dds].[DimTimeOfDay]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
