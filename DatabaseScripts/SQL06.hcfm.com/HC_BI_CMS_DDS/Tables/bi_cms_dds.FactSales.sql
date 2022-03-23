/* CreateDate: 03/17/2022 11:57:08.093 , ModifyDate: 03/17/2022 11:57:18.630 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
