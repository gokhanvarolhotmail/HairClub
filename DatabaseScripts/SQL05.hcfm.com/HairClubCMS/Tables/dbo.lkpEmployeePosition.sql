/* CreateDate: 05/05/2020 17:42:38.377 , ModifyDate: 05/05/2020 18:41:10.580 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
