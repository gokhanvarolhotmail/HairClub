/* CreateDate: 05/03/2010 12:19:13.273 , ModifyDate: 05/03/2010 12:19:13.947 */
GO
CREATE TABLE [bi_cms_dqa].[FactSales](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[OrderDateKey] [int] NULL,
	[OrderDate] [datetime] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderSSID] [uniqueidentifier] NULL,
	[SalesOrderTypeKey] [int] NULL,
	[SalesOrderTypeSSID] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientHomeCenterKey] [int] NULL,
	[ClientHomeCenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[MembershipKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeSSID] [uniqueidentifier] NULL,
	[IsRefunded] [tinyint] NULL,
	[IsTaxExempt] [tinyint] NULL,
	[IsWrittenOff] [tinyint] NULL,
	[IsVoided] [tinyint] NULL,
	[IsClosed] [tinyint] NULL,
	[TotalDiscount] [money] NULL,
	[TotalTax] [money] NULL,
	[TotalExtendedPrice] [money] NULL,
	[TotalExtendedPricePlusTax] [money] NULL,
	[TotalTender] [money] NULL,
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
 CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsVoided]  DEFAULT ((0)) FOR [IsVoided]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsClosed]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsNew_1]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsUpdate_1]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_dqa].[FactSales] ADD  CONSTRAINT [DF_FactSales_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
