create procedure [sp_MSupd_dboEmployeeHoursCertipay]
		@c1 varchar(64) = NULL,
		@c2 varchar(64) = NULL,
		@c3 int = NULL,
		@c4 varchar(50) = NULL,
		@c5 varchar(50) = NULL,
		@c6 datetime = NULL,
		@c7 datetime = NULL,
		@c8 datetime = NULL,
		@c9 real = NULL,
		@c10 real = NULL,
		@c11 real = NULL,
		@c12 real = NULL,
		@c13 int = NULL,
		@c14 datetime = NULL,
		@c15 int = NULL,
		@c16 real = NULL,
		@c17 real = NULL,
		@c18 real = NULL,
		@c19 bigint = NULL,
		@c20 bigint = NULL,
		@c21 bigint = NULL,
		@c22 bigint = NULL,
		@c23 bigint = NULL,
		@c24 bigint = NULL,
		@c25 bigint = NULL,
		@c26 real = NULL,
		@c27 bigint = NULL,
		@c28 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[EmployeeHoursCertipay] set
		[LastName] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [LastName] end,
		[FirstName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [FirstName] end,
		[HomeDepartment] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [HomeDepartment] end,
		[EmployeeNumber] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeeNumber] end,
		[EmployeeID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EmployeeID] end,
		[PeriodBegin] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [PeriodBegin] end,
		[PeriodEnd] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [PeriodEnd] end,
		[CheckDate] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [CheckDate] end,
		[SalaryHours] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SalaryHours] end,
		[RegularHours] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [RegularHours] end,
		[OverTimeHours] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [OverTimeHours] end,
		[PTO_Hours] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [PTO_Hours] end,
		[PerformerHomeCenter] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [PerformerHomeCenter] end,
		[ImportDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ImportDate] end,
		[GeneralLedger] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [GeneralLedger] end,
		[PTHours] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PTHours] end,
		[FuneralHours] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [FuneralHours] end,
		[JuryHours] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [JuryHours] end,
		[SalaryEarnings] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [SalaryEarnings] end,
		[RegularEarnings] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RegularEarnings] end,
		[OTEarnings] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [OTEarnings] end,
		[PTEarnings] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [PTEarnings] end,
		[PTOEarnings] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [PTOEarnings] end,
		[FuneralEarnings] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [FuneralEarnings] end,
		[JuryEarnings] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [JuryEarnings] end,
		[TravelHours] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [TravelHours] end,
		[TravelEarnings] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [TravelEarnings] end
	where [ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[EmployeeHoursCertipay]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
