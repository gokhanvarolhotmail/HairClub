CREATE TABLE [dbo].[datActivity](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[MasterActivityID] [int] NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ActivitySubCategoryID] [int] NULL,
	[ActivityActionID] [int] NOT NULL,
	[ActivityResultID] [int] NULL,
	[DueDate] [datetime] NOT NULL,
	[ActivityPriorityID] [int] NOT NULL,
	[ActivityNote] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedByEmployeeGUID] [uniqueidentifier] NOT NULL,
	[AssignedToEmployeeGUID] [uniqueidentifier] NOT NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[CompletedDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[ActivityStatusID] [int] NOT NULL,
 CONSTRAINT [PK_datActivity] PRIMARY KEY CLUSTERED
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivity_AssignedToEmployeeGUID_DueDate_CreateDate] ON [dbo].[datActivity]
(
	[AssignedToEmployeeGUID] ASC,
	[DueDate] ASC,
	[CreateDate] ASC
)
INCLUDE([ActivityStatusID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datActivity_ClientGUID_DueDate] ON [dbo].[datActivity]
(
	[ClientGUID] ASC,
	[DueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_datActivity_MasterActivity] FOREIGN KEY([MasterActivityID])
REFERENCES [dbo].[datActivity] ([ActivityID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_datActivity_MasterActivity]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_datClient]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_datEmployee_AssignedTo] FOREIGN KEY([AssignedToEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_datEmployee_AssignedTo]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_datEmployee_CompletedBy] FOREIGN KEY([CompletedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_datEmployee_CompletedBy]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_datEmployee_CreatedBy] FOREIGN KEY([CreatedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_datEmployee_CreatedBy]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_lkpActivityAction] FOREIGN KEY([ActivityActionID])
REFERENCES [dbo].[lkpActivityAction] ([ActivityActionID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_lkpActivityAction]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_lkpActivityPriority] FOREIGN KEY([ActivityPriorityID])
REFERENCES [dbo].[lkpActivityPriority] ([ActivityPriorityID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_lkpActivityPriority]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_lkpActivityResult] FOREIGN KEY([ActivityResultID])
REFERENCES [dbo].[lkpActivityResult] ([ActivityResultID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_lkpActivityResult]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_lkpActivityStatus] FOREIGN KEY([ActivityStatusID])
REFERENCES [dbo].[lkpActivityStatus] ([ActivityStatusID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_lkpActivityStatus]
GO
ALTER TABLE [dbo].[datActivity]  WITH CHECK ADD  CONSTRAINT [FK_datActivity_lkpActivitySubCategory] FOREIGN KEY([ActivitySubCategoryID])
REFERENCES [dbo].[lkpActivitySubCategory] ([ActivitySubCategoryID])
GO
ALTER TABLE [dbo].[datActivity] CHECK CONSTRAINT [FK_datActivity_lkpActivitySubCategory]
