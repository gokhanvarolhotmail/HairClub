/* CreateDate: 05/03/2010 12:19:43.177 , ModifyDate: 05/02/2021 19:41:38.767 */
GO
CREATE TABLE [bi_cms_stage].[DimSalesOrderTender](
	[DataPkgKey] [int] NULL,
	[SalesOrderTenderKey] [int] NULL,
	[SalesOrderTenderSSID] [uniqueidentifier] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderSSID] [uniqueidentifier] NULL,
	[OrderDate] [datetime] NULL,
	[TenderTypeSSID] [int] NULL,
	[TenderTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TenderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[Amount] [money] NULL,
	[CheckNumber] [int] NULL,
	[CreditCardLast4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApprovalCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreditCardTypeSSID] [int] NULL,
	[CreditCardTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreditCardTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FinanceCompanySSID] [int] NULL,
	[FinanceCompanyDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FinanceCompanyDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InterCompanyReasonSSID] [int] NULL,
	[InterCompanyReasonDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InterCompanyReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderTender_SalesOrderTenderSSID_DataPkgKey] ON [bi_cms_stage].[DimSalesOrderTender]
(
	[DataPkgKey] ASC,
	[SalesOrderTenderSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsType1] ASC,
	[IsType2] ASC,
	[IsDelete] ASC,
	[IsInferredMember] ASC
)
INCLUDE([IsDuplicate],[IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_DimSalesOrderTender_DataPkgKey] ON [bi_cms_stage].[DimSalesOrderTender]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_Amount]  DEFAULT ((0)) FOR [Amount]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsType1]  DEFAULT ((0)) FOR [IsType1]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsType2]  DEFAULT ((0)) FOR [IsType2]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsInferredMember]  DEFAULT ((0)) FOR [IsInferredMember]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[DimSalesOrderTender] ADD  CONSTRAINT [DF_DimSalesOrderTender_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
