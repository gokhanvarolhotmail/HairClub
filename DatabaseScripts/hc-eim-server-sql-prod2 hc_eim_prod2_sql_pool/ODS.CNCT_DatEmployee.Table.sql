/****** Object:  Table [ODS].[CNCT_DatEmployee]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_DatEmployee]
(
	[EmployeeGUID] [varchar](8000) NULL,
	[CenterID] [int] NULL,
	[TrainingExerciseID] [int] NULL,
	[ResourceID] [int] NULL,
	[SalutationID] [int] NULL,
	[FirstName] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[EmployeeInitials] [varchar](8000) NULL,
	[UserLogin] [varchar](8000) NULL,
	[Address1] [varchar](8000) NULL,
	[Address2] [varchar](8000) NULL,
	[Address3] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[StateID] [int] NULL,
	[PostalCode] [varchar](8000) NULL,
	[PhoneMain] [varchar](8000) NULL,
	[PhoneAlternate] [varchar](8000) NULL,
	[EmergencyContact] [varchar](8000) NULL,
	[PayrollNumber] [varchar](8000) NULL,
	[TimeClockNumber] [varchar](8000) NULL,
	[LastLogin] [datetime2](7) NULL,
	[IsSchedulerViewOnlyFlag] [bit] NULL,
	[EmployeeFullNameCalc] [varchar](8000) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[AbbreviatedNameCalc] [varchar](8000) NULL,
	[ActiveDirectorySID] [varbinary](max) NULL,
	[EmployeePayrollID] [varchar](8000) NULL,
	[EmployeeTitleID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
