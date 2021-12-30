/* CreateDate: 07/30/2012 09:01:56.307 , ModifyDate: 12/28/2021 09:20:54.647 */
GO
CREATE TABLE [dbo].[cfgActiveDirectoryGroupJoin](
	[ActiveDirectoryGroupID] [int] NOT NULL,
	[EmployeePositionID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[ActiveDirectoryGroupJoinID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
 CONSTRAINT [PK_cfgActiveDirectoryGroupJoin] PRIMARY KEY CLUSTERED
(
	[ActiveDirectoryGroupID] ASC,
	[EmployeePositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgActiveDirectoryGroupJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgActiveDirectoryGroupJoin_cfgActiveDirectoryGroup] FOREIGN KEY([ActiveDirectoryGroupID])
REFERENCES [dbo].[cfgActiveDirectoryGroup] ([ActiveDirectoryGroupID])
GO
ALTER TABLE [dbo].[cfgActiveDirectoryGroupJoin] CHECK CONSTRAINT [FK_cfgActiveDirectoryGroupJoin_cfgActiveDirectoryGroup]
GO
ALTER TABLE [dbo].[cfgActiveDirectoryGroupJoin]  WITH CHECK ADD  CONSTRAINT [FK_cfgActiveDirectoryGroupJoin_lkpEmployeePosition] FOREIGN KEY([EmployeePositionID])
REFERENCES [dbo].[lkpEmployeePosition] ([EmployeePositionID])
GO
ALTER TABLE [dbo].[cfgActiveDirectoryGroupJoin] CHECK CONSTRAINT [FK_cfgActiveDirectoryGroupJoin_lkpEmployeePosition]
GO
