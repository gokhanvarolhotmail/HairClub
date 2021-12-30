/* CreateDate: 05/05/2020 17:42:39.583 , ModifyDate: 05/05/2020 17:42:39.583 */
GO
create procedure [sp_MSupd_dbodatEmployee]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(5) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 nvarchar(50) = NULL,
		@c14 int = NULL,
		@c15 nchar(10) = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 nvarchar(25) = NULL,
		@c18 nvarchar(100) = NULL,
		@c19 nvarchar(20) = NULL,
		@c20 nvarchar(20) = NULL,
		@c21 datetime = NULL,
		@c22 bit = NULL,
		@c23 bit = NULL,
		@c24 datetime = NULL,
		@c25 nvarchar(25) = NULL,
		@c26 datetime = NULL,
		@c27 nvarchar(25) = NULL,
		@c28 varbinary(100) = NULL,
		@c29 nvarchar(20) = NULL,
		@c30 int = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datEmployee] set
		[EmployeeGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [EmployeeGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[TrainingExerciseID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TrainingExerciseID] end,
		[ResourceID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ResourceID] end,
		[SalutationID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalutationID] end,
		[FirstName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [FirstName] end,
		[LastName] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastName] end,
		[EmployeeInitials] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EmployeeInitials] end,
		[UserLogin] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UserLogin] end,
		[Address1] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Address1] end,
		[Address2] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Address2] end,
		[Address3] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Address3] end,
		[City] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [City] end,
		[StateID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [StateID] end,
		[PostalCode] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PostalCode] end,
		[PhoneMain] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PhoneMain] end,
		[PhoneAlternate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PhoneAlternate] end,
		[EmergencyContact] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [EmergencyContact] end,
		[PayrollNumber] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [PayrollNumber] end,
		[TimeClockNumber] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [TimeClockNumber] end,
		[LastLogin] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastLogin] end,
		[IsSchedulerViewOnlyFlag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [IsSchedulerViewOnlyFlag] end,
		[IsActiveFlag] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [LastUpdateUser] end,
		[ActiveDirectorySID] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [ActiveDirectorySID] end,
		[EmployeePayrollID] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [EmployeePayrollID] end,
		[EmployeeTitleID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [EmployeeTitleID] end
	where [EmployeeGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datEmployee]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datEmployee] set
		[CenterID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [CenterID] end,
		[TrainingExerciseID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [TrainingExerciseID] end,
		[ResourceID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ResourceID] end,
		[SalutationID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [SalutationID] end,
		[FirstName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [FirstName] end,
		[LastName] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [LastName] end,
		[EmployeeInitials] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EmployeeInitials] end,
		[UserLogin] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [UserLogin] end,
		[Address1] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [Address1] end,
		[Address2] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [Address2] end,
		[Address3] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [Address3] end,
		[City] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [City] end,
		[StateID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [StateID] end,
		[PostalCode] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [PostalCode] end,
		[PhoneMain] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [PhoneMain] end,
		[PhoneAlternate] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PhoneAlternate] end,
		[EmergencyContact] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [EmergencyContact] end,
		[PayrollNumber] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [PayrollNumber] end,
		[TimeClockNumber] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [TimeClockNumber] end,
		[LastLogin] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [LastLogin] end,
		[IsSchedulerViewOnlyFlag] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [IsSchedulerViewOnlyFlag] end,
		[IsActiveFlag] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [LastUpdateUser] end,
		[ActiveDirectorySID] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [ActiveDirectorySID] end,
		[EmployeePayrollID] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [EmployeePayrollID] end,
		[EmployeeTitleID] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [EmployeeTitleID] end
	where [EmployeeGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datEmployee]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
