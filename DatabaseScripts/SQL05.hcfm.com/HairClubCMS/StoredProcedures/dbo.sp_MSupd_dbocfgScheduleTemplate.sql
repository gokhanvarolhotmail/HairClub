/* CreateDate: 05/05/2020 17:42:44.963 , ModifyDate: 05/05/2020 17:42:44.963 */
GO
create procedure [sp_MSupd_dbocfgScheduleTemplate]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 time(0) = NULL,
		@c6 time(0) = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 bit = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(25) = NULL,
		@c12 datetime = NULL,
		@c13 nvarchar(25) = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[cfgScheduleTemplate] set
		[ScheduleTemplateGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [ScheduleTemplateGUID] end,
		[ScheduleTemplateDayOfWeek] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ScheduleTemplateDayOfWeek] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeeGUID] end,
		[StartTime] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [StartTime] end,
		[EndTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EndTime] end,
		[ScheduleTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ScheduleTypeID] end,
		[ScheduleCalendarTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ScheduleCalendarTypeID] end,
		[IsActiveScheduleFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveScheduleFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end
	where [ScheduleTemplateGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ScheduleTemplateGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgScheduleTemplate]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[cfgScheduleTemplate] set
		[ScheduleTemplateDayOfWeek] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ScheduleTemplateDayOfWeek] end,
		[CenterID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterID] end,
		[EmployeeGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeeGUID] end,
		[StartTime] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [StartTime] end,
		[EndTime] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EndTime] end,
		[ScheduleTypeID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ScheduleTypeID] end,
		[ScheduleCalendarTypeID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ScheduleCalendarTypeID] end,
		[IsActiveScheduleFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsActiveScheduleFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [LastUpdateUser] end
	where [ScheduleTemplateGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ScheduleTemplateGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[cfgScheduleTemplate]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
