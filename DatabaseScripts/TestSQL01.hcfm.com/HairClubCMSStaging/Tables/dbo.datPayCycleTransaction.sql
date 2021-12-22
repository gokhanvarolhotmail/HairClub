/* CreateDate: 05/14/2012 17:33:38.557 , ModifyDate: 07/15/2021 08:00:20.193 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datPayCycleTransaction](
	[PayCycleTransactionGUID] [uniqueidentifier] NOT NULL,
	[PayCycleTransactionTypeID] [int] NOT NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NOT NULL,
	[CenterDeclineBatchGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ProcessorTransactionID] [bigint] NULL,
	[ApprovalCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeAmount] [money] NOT NULL,
	[TaxAmount] [money] NOT NULL,
	[ChargeAmount] [money] NOT NULL,
	[Verbiage] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SoftCode] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HardCode] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Last4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExpirationDate] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTokenUsedFlag] [bit] NOT NULL,
	[IsCardPresentFlag] [bit] NOT NULL,
	[IsSuccessfulFlag] [bit] NOT NULL,
	[IsReprocessFlag] [bit] NOT NULL,
	[TransactionErrorMessage] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AVSResult] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HCStatusCode] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPayCycleTransaction] PRIMARY KEY CLUSTERED
(
	[PayCycleTransactionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_CenterDeclineBatchGUID] ON [dbo].[datPayCycleTransaction]
(
	[CenterDeclineBatchGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_CenterFeeBatchGUID] ON [dbo].[datPayCycleTransaction]
(
	[CenterFeeBatchGUID] ASC
)
INCLUDE([PayCycleTransactionTypeID],[CenterDeclineBatchGUID],[SalesOrderGUID],[ClientGUID],[ApprovalCode],[FeeAmount],[TaxAmount],[ChargeAmount],[Verbiage],[Last4Digits],[ExpirationDate],[IsSuccessfulFlag],[IsReprocessFlag],[CreateDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_CenterFeeBatchGUID_CenterDeclineBatchGUID_ChargeAmount] ON [dbo].[datPayCycleTransaction]
(
	[CenterFeeBatchGUID] ASC,
	[CenterDeclineBatchGUID] ASC
)
INCLUDE([ChargeAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_CenterFeeBatchGUID_CenterDeclineBatchGUID_ClientGUID] ON [dbo].[datPayCycleTransaction]
(
	[CenterFeeBatchGUID] ASC,
	[CenterDeclineBatchGUID] ASC,
	[ClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_CenterFeeBatchGUID_CenterDeclineBatchGUID_IsSuccessful_IsReprocess] ON [dbo].[datPayCycleTransaction]
(
	[CenterFeeBatchGUID] ASC,
	[CenterDeclineBatchGUID] ASC,
	[IsSuccessfulFlag] ASC,
	[IsReprocessFlag] ASC
)
INCLUDE([PayCycleTransactionGUID],[PayCycleTransactionTypeID],[SalesOrderGUID],[ClientGUID],[FeeAmount],[ChargeAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_CenterFeeBatchGUID_PayCycleTransactionTypeID_IsSuccessfulFlag] ON [dbo].[datPayCycleTransaction]
(
	[CenterFeeBatchGUID] ASC
)
INCLUDE([IsSuccessfulFlag],[PayCycleTransactionTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPayCycleTransaction_ClientGUID_CreateDate_IsSuccessfulFlag] ON [dbo].[datPayCycleTransaction]
(
	[ClientGUID] ASC,
	[IsSuccessfulFlag] ASC,
	[CreateDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPayCycleTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datPayCycleTransaction_datCenterDeclineBatch1] FOREIGN KEY([CenterDeclineBatchGUID])
REFERENCES [dbo].[datCenterDeclineBatch] ([CenterDeclineBatchGUID])
GO
ALTER TABLE [dbo].[datPayCycleTransaction] CHECK CONSTRAINT [FK_datPayCycleTransaction_datCenterDeclineBatch1]
GO
ALTER TABLE [dbo].[datPayCycleTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datPayCycleTransaction_datCenterFeeBatch1] FOREIGN KEY([CenterFeeBatchGUID])
REFERENCES [dbo].[datCenterFeeBatch] ([CenterFeeBatchGUID])
GO
ALTER TABLE [dbo].[datPayCycleTransaction] CHECK CONSTRAINT [FK_datPayCycleTransaction_datCenterFeeBatch1]
GO
ALTER TABLE [dbo].[datPayCycleTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datPayCycleTransaction_datClient1] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datPayCycleTransaction] CHECK CONSTRAINT [FK_datPayCycleTransaction_datClient1]
GO
ALTER TABLE [dbo].[datPayCycleTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datPayCycleTransaction_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datPayCycleTransaction] CHECK CONSTRAINT [FK_datPayCycleTransaction_datSalesOrder]
GO
ALTER TABLE [dbo].[datPayCycleTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datPayCycleTransaction_lkpPayCycleTransactionType1] FOREIGN KEY([PayCycleTransactionTypeID])
REFERENCES [dbo].[lkpPayCycleTransactionType] ([PayCycleTransactionTypeID])
GO
ALTER TABLE [dbo].[datPayCycleTransaction] CHECK CONSTRAINT [FK_datPayCycleTransaction_lkpPayCycleTransactionType1]
GO
