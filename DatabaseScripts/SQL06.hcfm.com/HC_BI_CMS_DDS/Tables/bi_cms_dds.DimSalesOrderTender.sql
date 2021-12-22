/* CreateDate: 10/03/2019 23:03:41.867 , ModifyDate: 12/01/2021 23:31:08.360 */
GO
CREATE TABLE [bi_cms_dds].[DimSalesOrderTender](
	[SalesOrderTenderKey] [int] NOT NULL,
	[SalesOrderTenderSSID] [uniqueidentifier] NOT NULL,
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderSSID] [uniqueidentifier] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[TenderTypeSSID] [int] NOT NULL,
	[TenderTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TenderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsVoidedFlag] [bit] NOT NULL,
	[IsClosedFlag] [bit] NOT NULL,
	[Amount] [money] NULL,
	[CheckNumber] [int] NOT NULL,
	[CreditCardLast4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ApprovalCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreditCardTypeSSID] [int] NOT NULL,
	[CreditCardTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreditCardTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FinanceCompanySSID] [int] NOT NULL,
	[FinanceCompanyDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FinanceCompanyDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InterCompanyReasonSSID] [int] NOT NULL,
	[InterCompanyReasonDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InterCompanyReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimSalesOrderTender] PRIMARY KEY CLUSTERED
(
	[SalesOrderTenderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderTender_RowIsCurrent_SalesOrderTenderSSID_SalesOrderTenderKey] ON [bi_cms_dds].[DimSalesOrderTender]
(
	[SalesOrderTenderSSID] ASC,
	[RowIsCurrent] ASC,
	[RowIsInferred] ASC
)
INCLUDE([SalesOrderTenderKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_DimSalesOrderTender_SalesOrderTenderKey] ON [bi_cms_dds].[DimSalesOrderTender]
(
	[SalesOrderTenderKey] ASC
)
INCLUDE([SalesOrderTenderSSID],[SalesOrderKey],[SalesOrderSSID],[OrderDate],[Amount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
