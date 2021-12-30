/* CreateDate: 05/05/2020 17:42:47.790 , ModifyDate: 05/05/2020 18:41:01.060 */
GO
CREATE TABLE [dbo].[datSalesOrder](
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[TenderTransactionNumber_Temp] [int] NULL,
	[TicketNumber_Temp] [int] NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[SalesOrderTypeID] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[OrderDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[RegisterCloseGUID] [uniqueidentifier] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[FulfillmentNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ParentSalesOrderGUID] [uniqueidentifier] NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[cashier_temp] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctrOrderDate] [datetime] NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NULL,
	[CenterDeclineBatchGUID] [uniqueidentifier] NULL,
	[RegisterID] [int] NULL,
	[EndOfDayGUID] [uniqueidentifier] NULL,
	[IncomingRequestID] [int] NULL,
	[WriteOffSalesOrderGUID] [uniqueidentifier] NULL,
	[NSFSalesOrderGUID] [uniqueidentifier] NULL,
	[ChargeBackSalesOrderGUID] [uniqueidentifier] NULL,
	[ChargebackReasonID] [int] NULL,
	[InterCompanyTransactionID] [int] NULL,
	[WriteOffReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datSalesOrder] PRIMARY KEY CLUSTERED
(
	[SalesOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_ClientGUID] ON [dbo].[datSalesOrder]
(
	[ClientGUID] ASC
)
INCLUDE([SalesOrderGUID],[ClientMembershipGUID],[OrderDate],[IsVoidedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_IsVoidedFlag_INCL] ON [dbo].[datSalesOrder]
(
	[IsVoidedFlag] ASC
)
INCLUDE([SalesOrderGUID],[CenterID],[ClientGUID],[ClientMembershipGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_LastUpdate] ON [dbo].[datSalesOrder]
(
	[LastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesOrder_OrderDateINCLSOGUIDCenterID] ON [dbo].[datSalesOrder]
(
	[OrderDate] ASC
)
INCLUDE([SalesOrderGUID],[CenterID],[SalesOrderTypeID],[ClientGUID],[ClientMembershipGUID],[IsVoidedFlag],[IsClosedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesorderDate_ctrOrderDateINCLCenterIDClientGUID] ON [dbo].[datSalesOrder]
(
	[ctrOrderDate] ASC
)
INCLUDE([SalesOrderGUID],[CenterID],[ClientGUID],[ClientMembershipGUID],[IsVoidedFlag],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrder_CenterID_INCLSSCOIEI] ON [dbo].[datSalesOrder]
(
	[CenterID] ASC
)
INCLUDE([SalesOrderGUID],[SalesOrderTypeID],[ClientGUID],[OrderDate],[IsVoidedFlag],[EmployeeGUID],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrder_ClientHomeCenterID] ON [dbo].[datSalesOrder]
(
	[ClientHomeCenterID] ASC,
	[IsVoidedFlag] ASC,
	[IsClosedFlag] ASC
)
INCLUDE([SalesOrderGUID],[SalesOrderTypeID],[ClientGUID],[ClientMembershipGUID],[OrderDate],[InvoiceNumber],[EmployeeGUID],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datSalesOrder_RefundedSalesOrderGUID_INCLOI] ON [dbo].[datSalesOrder]
(
	[RefundedSalesOrderGUID] ASC
)
INCLUDE([OrderDate],[InvoiceNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
