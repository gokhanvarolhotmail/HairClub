CREATE TABLE [dbo].[datCenterDeclineBatch](
	[CenterDeclineBatchGUID] [uniqueidentifier] NOT NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NOT NULL,
	[RunDate] [datetime] NULL,
	[RunByEmployeeGUID] [uniqueidentifier] NULL,
	[IsCompletedFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsExported] [int] NOT NULL,
	[CenterDeclineBatchStatusID] [int] NOT NULL,
 CONSTRAINT [PK_datCenterDeclineBatch] PRIMARY KEY CLUSTERED
(
	[CenterDeclineBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datCenterDeclineBatch_CenterFeeBatchGUID] ON [dbo].[datCenterDeclineBatch]
(
	[CenterFeeBatchGUID] ASC
)
INCLUDE([CenterDeclineBatchGUID],[CenterDeclineBatchStatusID],[RunDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datCenterDeclineBatch_CreateDate_CenterDeclineBatchGUID_CenterFeeBatchGUID] ON [dbo].[datCenterDeclineBatch]
(
	[CreateDate] ASC
)
INCLUDE([CenterDeclineBatchGUID],[CenterFeeBatchGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datCenterDeclineBatch] ADD  DEFAULT ((0)) FOR [IsExported]
GO
ALTER TABLE [dbo].[datCenterDeclineBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterDeclineBatch_datCenterFeeBatch] FOREIGN KEY([CenterFeeBatchGUID])
REFERENCES [dbo].[datCenterFeeBatch] ([CenterFeeBatchGUID])
GO
ALTER TABLE [dbo].[datCenterDeclineBatch] CHECK CONSTRAINT [FK_datCenterDeclineBatch_datCenterFeeBatch]
GO
ALTER TABLE [dbo].[datCenterDeclineBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterDeclineBatch_datEmployee] FOREIGN KEY([RunByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datCenterDeclineBatch] CHECK CONSTRAINT [FK_datCenterDeclineBatch_datEmployee]
GO
ALTER TABLE [dbo].[datCenterDeclineBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterDeclineBatch_lkpCenterDeclineBatchStatus] FOREIGN KEY([CenterDeclineBatchStatusID])
REFERENCES [dbo].[lkpCenterDeclineBatchStatus] ([CenterDeclineBatchStatusID])
GO
ALTER TABLE [dbo].[datCenterDeclineBatch] CHECK CONSTRAINT [FK_datCenterDeclineBatch_lkpCenterDeclineBatchStatus]
