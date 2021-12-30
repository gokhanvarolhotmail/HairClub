/* CreateDate: 12/16/2019 08:39:37.453 , ModifyDate: 12/16/2019 08:39:38.667 */
GO
CREATE TABLE [dbo].[cfgEmployeeGoal](
	[EmployeeGoalID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeGoalSortOrder] [int] NOT NULL,
	[EmployeeGoalDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeeGoalDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmployeeGoalDataTypeID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgEmployeeGoal] PRIMARY KEY CLUSTERED
(
	[EmployeeGoalID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgEmployeeGoal]  WITH CHECK ADD  CONSTRAINT [FK_cfgEmployeeGoal_lkpEmployeeGoalDataType] FOREIGN KEY([EmployeeGoalDataTypeID])
REFERENCES [dbo].[lkpEmployeeGoalDataType] ([EmployeeGoalDataTypeID])
GO
ALTER TABLE [dbo].[cfgEmployeeGoal] CHECK CONSTRAINT [FK_cfgEmployeeGoal_lkpEmployeeGoalDataType]
GO
