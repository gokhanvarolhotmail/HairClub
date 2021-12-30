/* CreateDate: 06/29/2011 09:44:15.177 , ModifyDate: 05/02/2021 19:41:20.887 */
GO
CREATE TABLE [bi_cms_stage].[DimSalesOrder](
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
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IncomingRequestID] [int] NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrder_SalesOrderSSID_DataPkgKey] ON [bi_cms_stage].[DimSalesOrder]
(
	[DataPkgKey] ASC,
	[SalesOrderSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimSalesOrder_DataPkgKey] ON [bi_cms_stage].[DimSalesOrder]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsTaxExemptFlag]  DEFAULT ((0)) FOR [IsTaxExemptFlag]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsVoidedFlag]  DEFAULT ((0)) FOR [IsVoidedFlag]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsClosedFlag]  DEFAULT ((0)) FOR [IsClosedFlag]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsWrittenOffFlag]  DEFAULT ((0)) FOR [IsWrittenOffFlag]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsRefundedFlag]  DEFAULT ((0)) FOR [IsRefundedFlag]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrder] ADD  CONSTRAINT [DF_DimSalesOrder_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
