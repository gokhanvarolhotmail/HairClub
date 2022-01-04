/* CreateDate: 05/05/2020 17:42:38.383 , ModifyDate: 05/05/2020 17:42:38.383 */
GO
create procedure [sp_MSins_dbolkpEmployeePosition]
    @c1 int,
    @c2 int,
    @c3 nvarchar(100),
    @c4 nvarchar(10),
    @c5 nvarchar(50),
    @c6 bit,
    @c7 bit,
    @c8 bit,
    @c9 bit,
    @c10 bit,
    @c11 bit,
    @c12 bit,
    @c13 datetime,
    @c14 nvarchar(25),
    @c15 datetime,
    @c16 nvarchar(25),
    @c17 int,
    @c18 bit,
    @c19 bit,
    @c20 bit,
    @c21 bit,
    @c22 bit,
    @c23 bit,
    @c24 bit,
    @c25 bit,
    @c26 bit,
    @c27 bit,
    @c28 bit,
    @c29 bit,
    @c30 bit,
    @c31 int,
    @c32 bit
as
begin
	insert into [dbo].[lkpEmployeePosition] (
		[EmployeePositionID],
		[EmployeePositionSortOrder],
		[EmployeePositionDescription],
		[EmployeePositionDescriptionShort],
		[ActiveDirectoryGroup],
		[IsAdministratorFlag],
		[CanScheduleFlag],
		[IsEmployeeOneFlag],
		[IsEmployeeTwoFlag],
		[IsEmployeeThreeFlag],
		[IsEmployeeFourFlag],
		[IsActiveFlag],
		[CreateDate],
		[CreateUser],
		[LastUpdate],
		[LastUpdateUser],
		[UpdateStamp],
		[ApplicationTimeoutMinutes],
		[UseDefaultCenterFlag],
		[IsSurgeryCenterEmployeeFlag],
		[IsNonSurgeryCenterEmployeeFlag],
		[IsMeasurementsBy],
		[IsConsultant],
		[IsTechnician],
		[IsStylist],
		[IsConsultationSchedule],
		[IsMembershipConsultant],
		[IsMembershipStylist],
		[CanScheduleStylist],
		[IsMembershipTechnician],
		[CanAssignActivityTo],
		[EmployeePositionTrainingGroupID],
		[IsCommissionable]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		default,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32	)
end
GO