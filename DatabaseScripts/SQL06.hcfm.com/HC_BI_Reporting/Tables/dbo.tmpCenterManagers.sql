/* CreateDate: 11/05/2020 10:32:48.673 , ModifyDate: 11/05/2020 13:34:41.037 */
GO
CREATE TABLE [dbo].[tmpCenterManagers](
	[Area] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[CenterNumber] [int] NULL,
	[CenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterManager] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterManagerUserGUID] [uniqueidentifier] NULL,
	[CenterManagerUserLogin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaDirector] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaDirectorUserGUID] [uniqueidentifier] NULL,
	[AreaDirectorUserLogin] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmpCenterManagers_CenterID] ON [dbo].[tmpCenterManagers]
(
	[CenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmpCenterManagers_CenterNumber] ON [dbo].[tmpCenterManagers]
(
	[CenterNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
