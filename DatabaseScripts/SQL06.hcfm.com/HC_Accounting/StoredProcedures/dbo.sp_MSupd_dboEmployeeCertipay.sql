create procedure [sp_MSupd_dboEmployeeCertipay]
		@c1 nvarchar(64) = NULL,
		@c2 nvarchar(64) = NULL,
		@c3 varchar(50) = NULL,
		@c4 varchar(50) = NULL,
		@c5 varchar(50) = NULL,
		@c6 varchar(12) = NULL,
		@c7 varchar(10) = NULL,
		@c8 varchar(7) = NULL,
		@c9 varchar(50) = NULL,
		@c10 varchar(50) = NULL,
		@c11 varchar(50) = NULL,
		@c12 int = NULL,
		@c13 varchar(50) = NULL,
		@c14 varchar(50) = NULL,
		@c15 varchar(25) = NULL,
		@c16 datetime = NULL,
		@c17 datetime = NULL,
		@c18 varchar(12) = NULL,
		@c19 tinyint = NULL,
		@c20 int = NULL,
		@c21 datetime = NULL,
		@c22 int = NULL,
		@c23 varchar(100) = NULL,
		@c24 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[EmployeeCertipay] set
		[LastName] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [LastName] end,
		[FirstName] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [FirstName] end,
		[Address] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [Address] end,
		[City] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [City] end,
		[State] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [State] end,
		[Zip] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [Zip] end,
		[Phone] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [Phone] end,
		[Gender] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [Gender] end,
		[JobCode] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [JobCode] end,
		[Title] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Title] end,
		[PayGroup] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [PayGroup] end,
		[HomeDepartment] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [HomeDepartment] end,
		[EmployeeID] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [EmployeeID] end,
		[EmployeeNumber] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [EmployeeNumber] end,
		[Status] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [Status] end,
		[HireDate] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [HireDate] end,
		[TerminationDate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [TerminationDate] end,
		[EmployeeType] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [EmployeeType] end,
		[CommissionFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [CommissionFlag] end,
		[PerformerHomeCenter] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [PerformerHomeCenter] end,
		[ImportDate] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [ImportDate] end,
		[GeneralLedger] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [GeneralLedger] end,
		[JobClassification] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [JobClassification] end
	where [ID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[EmployeeCertipay]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
