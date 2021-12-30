/* CreateDate: 05/14/2012 17:29:16.290 , ModifyDate: 05/26/2020 10:49:45.267 */
GO
CREATE TABLE [dbo].[datCenterFeeBatch](
	[CenterFeeBatchGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NOT NULL,
	[FeePayCycleID] [int] NOT NULL,
	[FeeMonth] [int] NOT NULL,
	[FeeYear] [int] NOT NULL,
	[CenterFeeBatchStatusId] [int] NOT NULL,
	[RunDate] [datetime] NULL,
	[RunByEmployeeGUID] [uniqueidentifier] NULL,
	[DownloadDate] [datetime] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsExported] [int] NOT NULL,
	[ApprovedDate] [datetime] NULL,
	[ApprovedByEmployeeGUID] [uniqueidentifier] NULL,
	[AreSalesOrdersCreated] [bit] NOT NULL,
	[IsMonetraProcessingCompleted] [bit] NOT NULL,
	[AreMonetraResultsProcessed] [bit] NOT NULL,
	[IsACHFileCreated] [bit] NOT NULL,
	[AreAccumulatorsExecuted] [bit] NOT NULL,
	[AreARPaymentsApplied] [bit] NOT NULL,
	[IsNACHAFileCreated] [bit] NOT NULL,
 CONSTRAINT [PK_datCenterFeeBatch] PRIMARY KEY CLUSTERED
(
	[CenterFeeBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UX_DatEFTCenterApproval] ON [dbo].[datCenterFeeBatch]
(
	[CenterID] ASC,
	[FeePayCycleID] ASC,
	[FeeMonth] ASC,
	[FeeYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [IsExported]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [AreSalesOrdersCreated]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [IsMonetraProcessingCompleted]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [AreMonetraResultsProcessed]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [IsACHFileCreated]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [AreAccumulatorsExecuted]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  DEFAULT ((0)) FOR [AreARPaymentsApplied]
GO
ALTER TABLE [dbo].[datCenterFeeBatch] ADD  CONSTRAINT [DF_datCenterFeeBatch_IsNACHAFileCreated]  DEFAULT ((0)) FOR [IsNACHAFileCreated]
GO
ALTER TABLE [dbo].[datCenterFeeBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterFeeBatch_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datCenterFeeBatch] CHECK CONSTRAINT [FK_datCenterFeeBatch_cfgCenter]
GO
ALTER TABLE [dbo].[datCenterFeeBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterFeeBatch_datEmployee] FOREIGN KEY([ApprovedByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datCenterFeeBatch] CHECK CONSTRAINT [FK_datCenterFeeBatch_datEmployee]
GO
ALTER TABLE [dbo].[datCenterFeeBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterFeeBatch_datEmployee1] FOREIGN KEY([RunByEmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datCenterFeeBatch] CHECK CONSTRAINT [FK_datCenterFeeBatch_datEmployee1]
GO
ALTER TABLE [dbo].[datCenterFeeBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterFeeBatch_lkpFeeCenterBatchStatus] FOREIGN KEY([CenterFeeBatchStatusId])
REFERENCES [dbo].[lkpCenterFeeBatchStatus] ([CenterFeeBatchStatusID])
GO
ALTER TABLE [dbo].[datCenterFeeBatch] CHECK CONSTRAINT [FK_datCenterFeeBatch_lkpFeeCenterBatchStatus]
GO
ALTER TABLE [dbo].[datCenterFeeBatch]  WITH CHECK ADD  CONSTRAINT [FK_datCenterFeeBatch_lkpFeePayCycle] FOREIGN KEY([FeePayCycleID])
REFERENCES [dbo].[lkpFeePayCycle] ([FeePayCycleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[datCenterFeeBatch] CHECK CONSTRAINT [FK_datCenterFeeBatch_lkpFeePayCycle]
GO
