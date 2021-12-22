create procedure [sp_MSupd_dboFactAccounting]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 datetime = NULL,
		@c4 int = NULL,
		@c5 real = NULL,
		@c6 real = NULL,
		@c7 real = NULL,
		@c8 real = NULL,
		@c9 real = NULL,
		@c10 real = NULL,
		@c11 datetime = NULL,
		@c12 int = NULL,
		@pkc1 int = NULL,
		@pkc2 int = NULL,
		@pkc3 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1) or
 (substring(@bitmap,1,1) & 2 = 2) or
 (substring(@bitmap,1,1) & 8 = 8)
begin
update [dbo].[FactAccounting] set
		[CenterID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [CenterID] end,
		[DateKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [DateKey] end,
		[PartitionDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PartitionDate] end,
		[AccountID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [AccountID] end,
		[Budget] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Budget] end,
		[Actual] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Actual] end,
		[Forecast] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Forecast] end,
		[Flash] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Flash] end,
		[FlashReporting] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [FlashReporting] end,
		[Drivers] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Drivers] end,
		[Timestamp] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Timestamp] end,
		[DoctorEntityID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DoctorEntityID] end
	where [CenterID] = @pkc1
  and [DateKey] = @pkc2
  and [AccountID] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[AccountID] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FactAccounting]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[FactAccounting] set
		[PartitionDate] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [PartitionDate] end,
		[Budget] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [Budget] end,
		[Actual] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Actual] end,
		[Forecast] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Forecast] end,
		[Flash] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Flash] end,
		[FlashReporting] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [FlashReporting] end,
		[Drivers] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Drivers] end,
		[Timestamp] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Timestamp] end,
		[DoctorEntityID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [DoctorEntityID] end
	where [CenterID] = @pkc1
  and [DateKey] = @pkc2
  and [AccountID] = @pkc3
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[CenterID] = ' + convert(nvarchar(100),@pkc1,1) + ', '
				set @primarykey_text = @primarykey_text + '[DateKey] = ' + convert(nvarchar(100),@pkc2,1) + ', '
				set @primarykey_text = @primarykey_text + '[AccountID] = ' + convert(nvarchar(100),@pkc3,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[FactAccounting]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
