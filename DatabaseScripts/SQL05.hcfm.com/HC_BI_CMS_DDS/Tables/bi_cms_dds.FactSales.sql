/* CreateDate: 05/03/2010 12:17:23.263 , ModifyDate: 11/21/2019 15:17:46.037 */
GO
CREATE TABLE [bi_cms_dds].[FactSales](
	[OrderDateKey] [int] NOT NULL,
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderTypeKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[ClientHomeCenterKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[IsRefunded] [int] NOT NULL,
	[IsTaxExempt] [int] NOT NULL,
	[IsWrittenOff] [int] NOT NULL,
	[TotalDiscount] [money] NOT NULL,
	[TotalTax] [money] NOT NULL,
	[TotalExtendedPrice] [money] NOT NULL,
	[TotalExtendedPricePlusTax] [money] NOT NULL,
	[TotalTender] [money] NOT NULL,
	[TenderVariance]  AS (isnull([TotalExtendedPricePlusTax],(0))-isnull([TotalTender],(0))),
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[IsClosed] [tinyint] NULL,
	[IsVoided] [tinyint] NULL,
 CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED
(
	[OrderDateKey] ASC,
	[SalesOrderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSales_ClientHomeCenterKey] ON [bi_cms_dds].[FactSales]
(
	[ClientHomeCenterKey] ASC
)
INCLUDE([ClientKey],[MembershipKey],[ClientMembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSales_SalesOrderKey] ON [bi_cms_dds].[FactSales]
(
	[SalesOrderKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderTypeKey],[CenterKey],[ClientKey],[MembershipKey],[ClientMembershipKey],[EmployeeKey],[ClientHomeCenterKey],[IsRefunded],[IsTaxExempt],[IsWrittenOff],[TotalDiscount],[TotalTax],[TotalExtendedPrice],[TotalExtendedPricePlusTax],[TotalTender],[TenderVariance]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSales_CenterKey] ON [bi_cms_dds].[FactSales]
(
	[CenterKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Temp_FactSales_ClientMembershipKey] ON [bi_cms_dds].[FactSales]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactSales] ADD  CONSTRAINT [MSrepl_tran_version_default_433987E8_DDB7_4D5B_8CFE_04D836D1D471_261575970]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
