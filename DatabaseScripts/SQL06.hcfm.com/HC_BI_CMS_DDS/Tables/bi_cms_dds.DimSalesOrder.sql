CREATE TABLE [bi_cms_dds].[DimSalesOrder](
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderSSID] [uniqueidentifier] NOT NULL,
	[TenderTransactionNumber_Temp] [int] NOT NULL,
	[TicketNumber_Temp] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[ClientHomeCenterKey] [int] NOT NULL,
	[ClientHomeCenterSSID] [int] NOT NULL,
	[SalesOrderTypeKey] [int] NOT NULL,
	[SalesOrderTypeSSID] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ClientSSID] [uniqueidentifier] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsTaxExemptFlag] [bit] NOT NULL,
	[IsVoidedFlag] [bit] NOT NULL,
	[IsClosedFlag] [bit] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[EmployeeSSID] [uniqueidentifier] NOT NULL,
	[FulfillmentNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsWrittenOffFlag] [bit] NOT NULL,
	[IsRefundedFlag] [bit] NOT NULL,
	[RefundedSalesOrderKey] [int] NOT NULL,
	[RefundedSalesOrderSSID] [uniqueidentifier] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IncomingRequestID] [int] NULL,
 CONSTRAINT [PK_DimSalesOrder] PRIMARY KEY CLUSTERED
(
	[SalesOrderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrder_CenterKey_OrderDate_IncludeColumns] ON [bi_cms_dds].[DimSalesOrder]
(
	[CenterKey] ASC,
	[OrderDate] ASC
)
INCLUDE([SalesOrderKey],[ClientKey],[EmployeeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrder_ClientMembershipKey_SalesOrderKey] ON [bi_cms_dds].[DimSalesOrder]
(
	[ClientMembershipKey] ASC
)
INCLUDE([SalesOrderKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrder_RowIsCurrent_SalesOrderSSID_SalesOrderKey] ON [bi_cms_dds].[DimSalesOrder]
(
	[SalesOrderSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesOrderKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrder_SalesOrderKey] ON [bi_cms_dds].[DimSalesOrder]
(
	[SalesOrderKey] ASC
)
INCLUDE([SalesOrderSSID],[OrderDate],[CenterKey],[ClientKey],[ClientMembershipKey],[SalesOrderTypeKey],[EmployeeKey],[InvoiceNumber],[IsClosedFlag],[IsVoidedFlag],[IsTaxExemptFlag],[IsWrittenOffFlag],[IsRefundedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_DimSalesOrder_SalesOrderSSID] ON [bi_cms_dds].[DimSalesOrder]
(
	[SalesOrderSSID] ASC
)
INCLUDE([CenterSSID],[OrderDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimSalesOrder_CenterSSID_IsVoidedFlag_OrderDate] ON [bi_cms_dds].[DimSalesOrder]
(
	[CenterSSID] ASC,
	[IsVoidedFlag] ASC,
	[OrderDate] ASC
)
INCLUDE([SalesOrderKey],[TicketNumber_Temp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimSalesOrder_IsVoidedFlag] ON [bi_cms_dds].[DimSalesOrder]
(
	[IsVoidedFlag] ASC,
	[ClientMembershipKey] ASC
)
INCLUDE([SalesOrderKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimSalesOrder_IsVoidedFlag_INCL] ON [bi_cms_dds].[DimSalesOrder]
(
	[IsVoidedFlag] ASC
)
INCLUDE([SalesOrderKey],[SalesOrderTypeKey],[ClientMembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [RP_DimSalesOrder_IsVoidedFlagOrderDate] ON [bi_cms_dds].[DimSalesOrder]
(
	[IsVoidedFlag] ASC,
	[OrderDate] ASC
)
INCLUDE([SalesOrderKey],[CenterSSID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
