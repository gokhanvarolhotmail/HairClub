/* CreateDate: 06/29/2011 09:47:04.500 , ModifyDate: 11/20/2013 11:35:53.697 */
GO
CREATE TABLE [bi_cms_dqa].[DimSalesOrder](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderSSID] [uniqueidentifier] NULL,
	[TenderTransactionNumber_Temp] [int] NULL,
	[TicketNumber_Temp] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientHomeCenterKey] [int] NULL,
	[ClientHomeCenterSSID] [int] NULL,
	[SalesOrderTypeKey] [int] NULL,
	[SalesOrderTypeSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[OrderDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [uniqueidentifier] NULL,
	[FulfillmentNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderKey] [int] NULL,
	[RefundedSalesOrderSSID] [uniqueidentifier] NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[ModifiedDate] [datetime] NULL,
	[IsNew] [tinyint] NULL,
	[IsType1] [tinyint] NULL,
	[IsType2] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsInferredMember] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IncomingRequestID] [int] NULL,
 CONSTRAINT [PK_DimSalesOrder] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
