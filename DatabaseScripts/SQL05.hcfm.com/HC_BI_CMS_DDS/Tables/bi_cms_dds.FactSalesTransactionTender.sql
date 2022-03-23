/* CreateDate: 05/03/2010 12:17:23.330 , ModifyDate: 03/17/2022 11:56:41.810 */
GO
CREATE TABLE [bi_cms_dds].[FactSalesTransactionTender](
	[OrderDateKey] [int] NOT NULL,
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderTenderKey] [int] NOT NULL,
	[SalesOrderTypeKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[TenderTypeKey] [int] NOT NULL,
	[TenderAmount] [money] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[IsClosed] [tinyint] NULL,
	[IsVoided] [tinyint] NULL,
	[AccountID] [int] NULL,
 CONSTRAINT [PK_FactSalesTransactionTender] PRIMARY KEY CLUSTERED
(
	[OrderDateKey] ASC,
	[SalesOrderKey] ASC,
	[SalesOrderTenderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSalesTransactionTender_SalesOrderTenderKey] ON [bi_cms_dds].[FactSalesTransactionTender]
(
	[SalesOrderTenderKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[SalesOrderTypeKey],[CenterKey],[ClientKey],[MembershipKey],[ClientMembershipKey],[TenderTypeKey],[TenderAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [Temp_FactSalesTransactionTender_ClientMembershipKey] ON [bi_cms_dds].[FactSalesTransactionTender]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_dds].[FactSalesTransactionTender] ADD  CONSTRAINT [MSrepl_tran_version_default_3FE83995_ECFA_4146_871A_C04B17AF132A_293576084]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
