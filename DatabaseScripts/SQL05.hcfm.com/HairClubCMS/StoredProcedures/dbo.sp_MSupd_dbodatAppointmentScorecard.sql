/* CreateDate: 05/05/2020 17:42:56.003 , ModifyDate: 05/05/2020 17:42:56.003 */
GO
create procedure [dbo].[sp_MSupd_dbodatAppointmentScorecard]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 datetime = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 datetime = NULL,
		@c7 nvarchar(25) = NULL,
		@c8 datetime = NULL,
		@c9 nvarchar(25) = NULL,
		@c10 binary(8) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datAppointmentScorecard] set
		[AppointmentScorecardID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AppointmentScorecardID] end,
		[AppointmentGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentGUID] end,
		[ScorecardCategoryID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ScorecardCategoryID] end,
		[CompleteDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CompleteDate] end,
		[CompletedByEmployeeGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CompletedByEmployeeGUID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [UpdateStamp] end
	where [AppointmentScorecardID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentScorecardID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAppointmentScorecard]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datAppointmentScorecard] set
		[AppointmentGUID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentGUID] end,
		[ScorecardCategoryID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ScorecardCategoryID] end,
		[CompleteDate] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CompleteDate] end,
		[CompletedByEmployeeGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [CompletedByEmployeeGUID] end,
		[CreateDate] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [LastUpdateUser] end,
		[UpdateStamp] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [UpdateStamp] end
	where [AppointmentScorecardID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentScorecardID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAppointmentScorecard]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
