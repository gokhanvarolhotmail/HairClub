/* CreateDate: 01/19/2009 12:41:32.723 , ModifyDate: 01/10/2021 03:43:08.257 */
GO
CREATE TABLE [dbo].[datSalesOrderTender](
	[SalesOrderTenderGUID] [uniqueidentifier] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[TenderTypeID] [int] NOT NULL,
	[Amount] [money] NULL,
	[CheckNumber] [int] NULL,
	[CreditCardLast4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApprovalCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreditCardTypeID] [int] NULL,
	[FinanceCompanyID] [int] NULL,
	[InterCompanyReasonID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[RefundAmount] [money] NULL,
	[MonetraTransactionId] [bigint] NULL,
	[EntrySortOrder] [int] NOT NULL,
	[CashCollected] [money] NULL,
 CONSTRAINT [PK_datSalesOrderTender] PRIMARY KEY CLUSTERED
(
	[SalesOrderTenderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrderTender_SalesOrderGUID_INCLTACCACF] ON [dbo].[datSalesOrderTender]
(
	[SalesOrderGUID] ASC
)
INCLUDE([TenderTypeID],[Amount],[CheckNumber],[CreditCardLast4Digits],[ApprovalCode],[CreditCardTypeID],[FinanceCompanyID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrderTender_TenderTypeID_INCLSACCACF] ON [dbo].[datSalesOrderTender]
(
	[TenderTypeID] ASC
)
INCLUDE([SalesOrderGUID],[Amount],[CheckNumber],[CreditCardLast4Digits],[ApprovalCode],[CreditCardTypeID],[FinanceCompanyID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesOrderTender] ADD  CONSTRAINT [DF_datSalesOrderTender_Amount]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [dbo].[datSalesOrderTender] ADD  CONSTRAINT [DF_datSalesOrderTender_EntrySortOrder]  DEFAULT ((1)) FOR [EntrySortOrder]
GO
ALTER TABLE [dbo].[datSalesOrderTender]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderTender_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datSalesOrderTender] CHECK CONSTRAINT [FK_datSalesOrderTender_datSalesOrder]
GO
ALTER TABLE [dbo].[datSalesOrderTender]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderTender_lkpCreditCardType] FOREIGN KEY([CreditCardTypeID])
REFERENCES [dbo].[lkpCreditCardType] ([CreditCardTypeID])
GO
ALTER TABLE [dbo].[datSalesOrderTender] CHECK CONSTRAINT [FK_datSalesOrderTender_lkpCreditCardType]
GO
ALTER TABLE [dbo].[datSalesOrderTender]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderTender_lkpFinanceCompany] FOREIGN KEY([FinanceCompanyID])
REFERENCES [dbo].[lkpFinanceCompany] ([FinanceCompanyID])
GO
ALTER TABLE [dbo].[datSalesOrderTender] CHECK CONSTRAINT [FK_datSalesOrderTender_lkpFinanceCompany]
GO
ALTER TABLE [dbo].[datSalesOrderTender]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderTender_lkpInterCompanyReason] FOREIGN KEY([InterCompanyReasonID])
REFERENCES [dbo].[lkpInterCompanyReason] ([InterCompanyReasonID])
GO
ALTER TABLE [dbo].[datSalesOrderTender] CHECK CONSTRAINT [FK_datSalesOrderTender_lkpInterCompanyReason]
GO
ALTER TABLE [dbo].[datSalesOrderTender]  WITH CHECK ADD  CONSTRAINT [FK_datSalesOrderTender_lkpTenderType] FOREIGN KEY([TenderTypeID])
REFERENCES [dbo].[lkpTenderType] ([TenderTypeID])
GO
ALTER TABLE [dbo].[datSalesOrderTender] CHECK CONSTRAINT [FK_datSalesOrderTender_lkpTenderType]
GO
