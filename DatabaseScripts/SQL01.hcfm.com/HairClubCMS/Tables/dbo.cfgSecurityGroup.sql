CREATE TABLE [dbo].[cfgSecurityGroup](
	[SecurityGroupID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[EmployeePositionID] [int] NULL,
	[SecurityElementID] [int] NULL,
	[HasAccessFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgSecurityPosition] PRIMARY KEY CLUSTERED
(
	[SecurityGroupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_cfgSecurityGroup_lkpEmployeePosition] FOREIGN KEY([EmployeePositionID])
REFERENCES [dbo].[lkpEmployeePosition] ([EmployeePositionID])
GO
ALTER TABLE [dbo].[cfgSecurityGroup] CHECK CONSTRAINT [FK_cfgSecurityGroup_lkpEmployeePosition]
GO
ALTER TABLE [dbo].[cfgSecurityGroup]  WITH CHECK ADD  CONSTRAINT [FK_cfgSecurityGroup_lkpSecurityElement] FOREIGN KEY([SecurityElementID])
REFERENCES [dbo].[lkpSecurityElement] ([SecurityElementID])
GO
ALTER TABLE [dbo].[cfgSecurityGroup] CHECK CONSTRAINT [FK_cfgSecurityGroup_lkpSecurityElement]
