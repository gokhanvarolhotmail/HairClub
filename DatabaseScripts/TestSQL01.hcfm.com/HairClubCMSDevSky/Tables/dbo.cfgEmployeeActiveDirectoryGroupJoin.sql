/* CreateDate: 07/30/2012 09:01:56.423 , ModifyDate: 02/02/2022 08:16:54.333 */
GO
CREATE TABLE [dbo].[cfgEmployeeActiveDirectoryGroupJoin](
	[EmployeeGUID] [uniqueidentifier] NOT NULL,
	[ActiveDirectoryGroupID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgEmployeeActiveDirectoryGroupJoin] PRIMARY KEY CLUSTERED
(
	[EmployeeGUID] ASC,
	[ActiveDirectoryGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgEmployeeActiveDirectoryGroupJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgEmployeeActiveDirectoryGroupJoin_cfgActiveDirectoryGroup] FOREIGN KEY([ActiveDirectoryGroupID])
REFERENCES [dbo].[cfgActiveDirectoryGroup] ([ActiveDirectoryGroupID])
GO
ALTER TABLE [dbo].[cfgEmployeeActiveDirectoryGroupJoin] CHECK CONSTRAINT [FK_cfgEmployeeActiveDirectoryGroupJoin_cfgActiveDirectoryGroup]
GO
ALTER TABLE [dbo].[cfgEmployeeActiveDirectoryGroupJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgEmployeeActiveDirectoryGroupJoin_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[cfgEmployeeActiveDirectoryGroupJoin] CHECK CONSTRAINT [FK_cfgEmployeeActiveDirectoryGroupJoin_datEmployee]
GO
