/* CreateDate: 05/05/2020 17:42:38.397 , ModifyDate: 05/05/2020 17:42:38.397 */
GO
create procedure [sp_MSupd_dbolkpEmployeePosition]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 nvarchar(100) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 bit = NULL,
		@c7 bit = NULL,
		@c8 bit = NULL,
		@c9 bit = NULL,
		@c10 bit = NULL,
		@c11 bit = NULL,
		@c12 bit = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(25) = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(25) = NULL,
		@c17 int = NULL,
		@c18 bit = NULL,
		@c19 bit = NULL,
		@c20 bit = NULL,
		@c21 bit = NULL,
		@c22 bit = NULL,
		@c23 bit = NULL,
		@c24 bit = NULL,
		@c25 bit = NULL,
		@c26 bit = NULL,
		@c27 bit = NULL,
		@c28 bit = NULL,
		@c29 bit = NULL,
		@c30 bit = NULL,
		@c31 int = NULL,
		@c32 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[lkpEmployeePosition] set
		[EmployeePositionID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [EmployeePositionID] end,
		[EmployeePositionSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EmployeePositionSortOrder] end,
		[EmployeePositionDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeePositionDescription] end,
		[EmployeePositionDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeePositionDescriptionShort] end,
		[ActiveDirectoryGroup] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActiveDirectoryGroup] end,
		[IsAdministratorFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsAdministratorFlag] end,
		[CanScheduleFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CanScheduleFlag] end,
		[IsEmployeeOneFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsEmployeeOneFlag] end,
		[IsEmployeeTwoFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsEmployeeTwoFlag] end,
		[IsEmployeeThreeFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsEmployeeThreeFlag] end,
		[IsEmployeeFourFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsEmployeeFourFlag] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdateUser] end,
		[ApplicationTimeoutMinutes] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ApplicationTimeoutMinutes] end,
		[UseDefaultCenterFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [UseDefaultCenterFlag] end,
		[IsSurgeryCenterEmployeeFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsSurgeryCenterEmployeeFlag] end,
		[IsNonSurgeryCenterEmployeeFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsNonSurgeryCenterEmployeeFlag] end,
		[IsMeasurementsBy] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [IsMeasurementsBy] end,
		[IsConsultant] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [IsConsultant] end,
		[IsTechnician] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsTechnician] end,
		[IsStylist] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [IsStylist] end,
		[IsConsultationSchedule] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [IsConsultationSchedule] end,
		[IsMembershipConsultant] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [IsMembershipConsultant] end,
		[IsMembershipStylist] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [IsMembershipStylist] end,
		[CanScheduleStylist] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CanScheduleStylist] end,
		[IsMembershipTechnician] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [IsMembershipTechnician] end,
		[CanAssignActivityTo] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CanAssignActivityTo] end,
		[EmployeePositionTrainingGroupID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [EmployeePositionTrainingGroupID] end,
		[IsCommissionable] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [IsCommissionable] end
	where [EmployeePositionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeePositionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpEmployeePosition]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[lkpEmployeePosition] set
		[EmployeePositionSortOrder] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EmployeePositionSortOrder] end,
		[EmployeePositionDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeePositionDescription] end,
		[EmployeePositionDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeePositionDescriptionShort] end,
		[ActiveDirectoryGroup] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ActiveDirectoryGroup] end,
		[IsAdministratorFlag] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [IsAdministratorFlag] end,
		[CanScheduleFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CanScheduleFlag] end,
		[IsEmployeeOneFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsEmployeeOneFlag] end,
		[IsEmployeeTwoFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsEmployeeTwoFlag] end,
		[IsEmployeeThreeFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsEmployeeThreeFlag] end,
		[IsEmployeeFourFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsEmployeeFourFlag] end,
		[IsActiveFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [IsActiveFlag] end,
		[CreateDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [LastUpdateUser] end,
		[ApplicationTimeoutMinutes] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [ApplicationTimeoutMinutes] end,
		[UseDefaultCenterFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [UseDefaultCenterFlag] end,
		[IsSurgeryCenterEmployeeFlag] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [IsSurgeryCenterEmployeeFlag] end,
		[IsNonSurgeryCenterEmployeeFlag] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [IsNonSurgeryCenterEmployeeFlag] end,
		[IsMeasurementsBy] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [IsMeasurementsBy] end,
		[IsConsultant] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [IsConsultant] end,
		[IsTechnician] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [IsTechnician] end,
		[IsStylist] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [IsStylist] end,
		[IsConsultationSchedule] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [IsConsultationSchedule] end,
		[IsMembershipConsultant] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [IsMembershipConsultant] end,
		[IsMembershipStylist] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [IsMembershipStylist] end,
		[CanScheduleStylist] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [CanScheduleStylist] end,
		[IsMembershipTechnician] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [IsMembershipTechnician] end,
		[CanAssignActivityTo] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [CanAssignActivityTo] end,
		[EmployeePositionTrainingGroupID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [EmployeePositionTrainingGroupID] end,
		[IsCommissionable] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [IsCommissionable] end
	where [EmployeePositionID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeePositionID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[lkpEmployeePosition]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
