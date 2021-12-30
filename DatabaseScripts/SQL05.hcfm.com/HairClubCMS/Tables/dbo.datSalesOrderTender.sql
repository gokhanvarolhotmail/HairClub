/* CreateDate: 05/05/2020 17:42:48.383 , ModifyDate: 05/05/2020 18:41:01.337 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
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
