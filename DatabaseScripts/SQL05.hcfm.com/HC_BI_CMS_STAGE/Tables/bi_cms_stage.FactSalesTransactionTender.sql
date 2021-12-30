/* CreateDate: 04/30/2013 14:19:53.947 , ModifyDate: 06/05/2014 14:38:34.973 */
GO
CREATE TABLE [bi_cms_stage].[FactSalesTransactionTender](
	[DataPkgKey] [int] NOT NULL,
	[OrderDateKey] [int] NULL,
	[OrderDate] [datetime] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderSSID] [uniqueidentifier] NULL,
	[SalesOrderTenderKey] [int] NULL,
	[SalesOrderTenderSSID] [uniqueidentifier] NULL,
	[SalesOrderTypeKey] [int] NULL,
	[SalesOrderTypeSSID] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[MembershipKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[TenderTypeKey] [int] NULL,
	[TenderTypeSSID] [int] NULL,
	[TenderAmount] [money] NULL,
	[IsVoided] [tinyint] NULL,
	[IsClosed] [tinyint] NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
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
	[AccountID] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsVoided]  DEFAULT ((0)) FOR [IsVoided]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
