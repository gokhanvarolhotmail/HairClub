/* CreateDate: 05/14/2012 17:33:38.987 , ModifyDate: 12/02/2021 04:04:59.450 */
GO
CREATE TABLE [dbo].[datAccountReceivable](
	[AccountReceivableID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NULL,
	[Amount] [money] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[AccountReceivableTypeID] [int] NOT NULL,
	[RemainingBalance] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[CenterDeclineBatchGUID] [uniqueidentifier] NULL,
	[RefundedSalesOrderGuid] [uniqueidentifier] NULL,
	[WriteOffSalesOrderGUID] [uniqueidentifier] NULL,
	[NSFSalesOrderGUID] [uniqueidentifier] NULL,
	[ChargeBackSalesOrderGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_datAccountReceivable] PRIMARY KEY CLUSTERED
(
	[AccountReceivableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivable_CenterDeclineBatchGUID_IsClosed] ON [dbo].[datAccountReceivable]
(
	[IsClosed] ASC,
	[CenterDeclineBatchGUID] ASC
)
INCLUDE([ClientGUID],[AccountReceivableTypeID],[CenterFeeBatchGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivable_CenterFeeBatchGUID_IsClosed] ON [dbo].[datAccountReceivable]
(
	[IsClosed] ASC,
	[CenterFeeBatchGUID] ASC
)
INCLUDE([ClientGUID],[AccountReceivableTypeID],[CenterDeclineBatchGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivable_ClientGUID_AccountReceivableTypeID_IsClosed] ON [dbo].[datAccountReceivable]
(
	[ClientGUID] ASC,
	[AccountReceivableTypeID] ASC,
	[IsClosed] ASC
)
INCLUDE([CenterFeeBatchGUID],[CenterDeclineBatchGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivable_ClientGUID_IsClosed] ON [dbo].[datAccountReceivable]
(
	[ClientGUID] ASC
)
INCLUDE([IsClosed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivable_IsClosed_ClientGUID] ON [dbo].[datAccountReceivable]
(
	[IsClosed] ASC,
	[ClientGUID] ASC
)
INCLUDE([AccountReceivableTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAccountReceivable_SalesOrderGUID] ON [dbo].[datAccountReceivable]
(
	[SalesOrderGUID] ASC
)
INCLUDE([IsClosed],[AccountReceivableTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datCenterDeclineBatch] FOREIGN KEY([CenterDeclineBatchGUID])
REFERENCES [dbo].[datCenterDeclineBatch] ([CenterDeclineBatchGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datCenterDeclineBatch]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datCenterFeeBatch] FOREIGN KEY([CenterFeeBatchGUID])
REFERENCES [dbo].[datCenterFeeBatch] ([CenterFeeBatchGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datCenterFeeBatch]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datClient1] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datClient1]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datSalesOrder] FOREIGN KEY([RefundedSalesOrderGuid])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datSalesOrder]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datSalesOrder1] FOREIGN KEY([WriteOffSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datSalesOrder1]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datSalesOrder2] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datSalesOrder2]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datSalesOrder3] FOREIGN KEY([NSFSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datSalesOrder3]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_datSalesOrder4] FOREIGN KEY([ChargeBackSalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_datSalesOrder4]
GO
ALTER TABLE [dbo].[datAccountReceivable]  WITH CHECK ADD  CONSTRAINT [FK_datAccountReceivable_lkpAccountReceivableType] FOREIGN KEY([AccountReceivableTypeID])
REFERENCES [dbo].[lkpAccountReceivableType] ([AccountReceivableTypeID])
GO
ALTER TABLE [dbo].[datAccountReceivable] CHECK CONSTRAINT [FK_datAccountReceivable_lkpAccountReceivableType]
GO
