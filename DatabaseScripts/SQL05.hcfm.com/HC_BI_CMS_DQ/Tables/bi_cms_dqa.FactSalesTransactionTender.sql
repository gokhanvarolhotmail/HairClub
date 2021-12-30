/* CreateDate: 05/03/2010 12:19:13.300 , ModifyDate: 06/05/2014 14:38:35.120 */
GO
CREATE TABLE [bi_cms_dqa].[FactSalesTransactionTender](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
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
	[CreateTimestamp] [datetime] NOT NULL,
	[AccountID] [int] NULL,
 CONSTRAINT [PK_FactSalesTransactionTender] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsVoided]  DEFAULT ((0)) FOR [IsVoided]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[FactSalesTransactionTender] ADD  CONSTRAINT [DF_FactSalesTransactionTender_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
