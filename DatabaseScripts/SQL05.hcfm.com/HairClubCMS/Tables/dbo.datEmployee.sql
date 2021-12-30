/* CreateDate: 05/05/2020 17:42:39.550 , ModifyDate: 05/05/2020 18:41:00.787 */
GO
CREATE TABLE [dbo].[datEmployee](
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NULL,
	[TrainingExerciseID] [int] NULL,
	[ResourceID] [int] NULL,
	[SalutationID] [int] NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeInitials] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserLogin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateID] [int] NULL,
	[PostalCode] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneMain] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneAlternate] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmergencyContact] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PayrollNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeClockNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastLogin] [datetime] NULL,
	[IsSchedulerViewOnlyFlag] [bit] NULL,
	[EmployeeFullNameCalc]  AS ((isnull([LastName],'')+', ')+isnull([FirstName],'')),
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[AbbreviatedNameCalc]  AS (ltrim(rtrim((isnull([FirstName],' ')+' ')+left(isnull([LastName],' '),(1))))),
	[ActiveDirectorySID] [varbinary](100) NULL,
	[EmployeePayrollID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeTitleID] [int] NULL,
 CONSTRAINT [PK_datEmployee] PRIMARY KEY CLUSTERED
(
	[EmployeeGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datEmployee_EmployeeGUID] ON [dbo].[datEmployee]
(
	[EmployeeGUID] ASC
)
INCLUDE([FirstName],[LastName],[EmployeeInitials],[UserLogin],[EmployeeFullNameCalc],[IsActiveFlag],[EmployeePayrollID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datEmployee_CenterID_IsActiveFlag] ON [dbo].[datEmployee]
(
	[CenterID] ASC,
	[IsActiveFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datEmployee_IsActiveFlag_INCLEE] ON [dbo].[datEmployee]
(
	[IsActiveFlag] ASC
)
INCLUDE([EmployeeGUID],[EmployeeFullNameCalc]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datEmployee]  WITH NOCHECK ADD  CONSTRAINT [FK_datEmployee_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[datEmployee] CHECK CONSTRAINT [FK_datEmployee_cfgCenter]
GO
