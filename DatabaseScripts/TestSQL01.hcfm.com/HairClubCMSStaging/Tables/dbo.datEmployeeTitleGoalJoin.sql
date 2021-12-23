/* CreateDate: 12/16/2019 08:39:37.493 , ModifyDate: 12/16/2019 08:39:38.643 */
GO
CREATE TABLE [dbo].[datEmployeeTitleGoalJoin](
	[EmployeeTitleGoalJoinID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeTitleGoalJoinSortOrder] [int] NOT NULL,
	[EmployeeTitleID] [int] NOT NULL,
	[EmployeeGoalID] [int] NOT NULL,
	[EmployeeGoalDataTypeID] [int] NOT NULL,
	[Quantity] [int] NULL,
	[Amount] [money] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datEmployeeTitleGoalJoin] PRIMARY KEY CLUSTERED
(
	[EmployeeTitleGoalJoinID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datEmployeeTitleGoalJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_datEmployeeTitleGoalJoin_cfgEmployeeGoal] FOREIGN KEY([EmployeeGoalID])
REFERENCES [dbo].[cfgEmployeeGoal] ([EmployeeGoalID])
GO
ALTER TABLE [dbo].[datEmployeeTitleGoalJoin] CHECK CONSTRAINT [FK_datEmployeeTitleGoalJoin_cfgEmployeeGoal]
GO
ALTER TABLE [dbo].[datEmployeeTitleGoalJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_datEmployeeTitleGoalJoin_lkpEmployeeGoalDataType] FOREIGN KEY([EmployeeGoalDataTypeID])
REFERENCES [dbo].[lkpEmployeeGoalDataType] ([EmployeeGoalDataTypeID])
GO
ALTER TABLE [dbo].[datEmployeeTitleGoalJoin] CHECK CONSTRAINT [FK_datEmployeeTitleGoalJoin_lkpEmployeeGoalDataType]
GO
ALTER TABLE [dbo].[datEmployeeTitleGoalJoin]  WITH NOCHECK ADD  CONSTRAINT [FK_datEmployeeTitleGoalJoin_lkpEmployeeTitle] FOREIGN KEY([EmployeeTitleID])
REFERENCES [dbo].[lkpEmployeeTitle] ([EmployeeTitleID])
GO
ALTER TABLE [dbo].[datEmployeeTitleGoalJoin] CHECK CONSTRAINT [FK_datEmployeeTitleGoalJoin_lkpEmployeeTitle]
GO
