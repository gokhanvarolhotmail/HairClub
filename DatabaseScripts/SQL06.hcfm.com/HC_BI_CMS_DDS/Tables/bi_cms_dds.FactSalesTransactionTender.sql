/* CreateDate: 03/17/2022 11:57:08.540 , ModifyDate: 03/17/2022 11:57:19.137 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
