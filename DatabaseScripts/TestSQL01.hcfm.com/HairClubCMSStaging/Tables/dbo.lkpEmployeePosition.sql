/* CreateDate: 04/14/2009 07:33:54.947 , ModifyDate: 05/26/2020 10:49:33.220 */
GO
CREATE TABLE [dbo].[lkpEmployeePosition](
	[EmployeePositionID] [int] NOT NULL,
	[EmployeePositionSortOrder] [int] NOT NULL,
	[EmployeePositionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeePositionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActiveDirectoryGroup] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAdministratorFlag] [bit] NULL,
	[CanScheduleFlag] [bit] NULL,
	[IsEmployeeOneFlag] [bit] NULL,
	[IsEmployeeTwoFlag] [bit] NULL,
	[IsEmployeeThreeFlag] [bit] NULL,
	[IsEmployeeFourFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ApplicationTimeoutMinutes] [int] NULL,
	[UseDefaultCenterFlag] [bit] NULL,
	[IsSurgeryCenterEmployeeFlag] [bit] NULL,
	[IsNonSurgeryCenterEmployeeFlag] [bit] NOT NULL,
	[IsMeasurementsBy] [bit] NULL,
	[IsConsultant] [bit] NULL,
	[IsTechnician] [bit] NULL,
	[IsStylist] [bit] NULL,
	[IsConsultationSchedule] [bit] NULL,
	[IsMembershipConsultant] [bit] NULL,
	[IsMembershipStylist] [bit] NULL,
	[CanScheduleStylist] [bit] NULL,
	[IsMembershipTechnician] [bit] NULL,
	[CanAssignActivityTo] [bit] NOT NULL,
	[EmployeePositionTrainingGroupID] [int] NULL,
	[IsCommissionable] [bit] NOT NULL,
 CONSTRAINT [PK_lkpEmployeePosition] PRIMARY KEY CLUSTERED
(
	[EmployeePositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_IsAdministratorFlag]  DEFAULT ((0)) FOR [IsAdministratorFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_CanScheduleFlag]  DEFAULT ((0)) FOR [CanScheduleFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_IsEmployeeOneFlag]  DEFAULT ((0)) FOR [IsEmployeeOneFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_IsEmployeeTwoFlag]  DEFAULT ((0)) FOR [IsEmployeeTwoFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_IsEmployeeThreeFlag]  DEFAULT ((0)) FOR [IsEmployeeThreeFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_IsEmployeeFourFlag]  DEFAULT ((0)) FOR [IsEmployeeFourFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  CONSTRAINT [DF_lkpEmployeePosition_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsSurgeryCenterEmployeeFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsNonSurgeryCenterEmployeeFlag]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsMeasurementsBy]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsConsultant]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsTechnician]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsStylist]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsConsultationSchedule]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsMembershipConsultant]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsMembershipStylist]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [CanScheduleStylist]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((0)) FOR [IsMembershipTechnician]
GO
ALTER TABLE [dbo].[lkpEmployeePosition] ADD  DEFAULT ((1)) FOR [CanAssignActivityTo]
GO
ALTER TABLE [dbo].[lkpEmployeePosition]  WITH CHECK ADD  CONSTRAINT [FK_lkpEmployeePosition_lkpEmployeePositionTrainingGroup] FOREIGN KEY([EmployeePositionTrainingGroupID])
REFERENCES [dbo].[lkpEmployeePositionTrainingGroup] ([EmployeePositionTrainingGroupID])
GO
ALTER TABLE [dbo].[lkpEmployeePosition] CHECK CONSTRAINT [FK_lkpEmployeePosition_lkpEmployeePositionTrainingGroup]
GO
