/* CreateDate: 03/17/2022 11:57:06.703 , ModifyDate: 03/17/2022 11:57:16.577 */
GO
CREATE TABLE [bi_cms_dds].[DimSalesOrder](
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderSSID] [uniqueidentifier] NOT NULL,
	[TenderTransactionNumber_Temp] [int] NOT NULL,
	[TicketNumber_Temp] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[ClientHomeCenterKey] [int] NOT NULL,
	[ClientHomeCenterSSID] [int] NOT NULL,
	[SalesOrderTypeKey] [int] NOT NULL,
	[SalesOrderTypeSSID] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ClientSSID] [uniqueidentifier] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ClientMembershipSSID] [uniqueidentifier] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsTaxExemptFlag] [bit] NOT NULL,
	[IsVoidedFlag] [bit] NOT NULL,
	[IsClosedFlag] [bit] NOT NULL,
	[EmployeeKey] [int] NOT NULL,
	[EmployeeSSID] [uniqueidentifier] NOT NULL,
	[FulfillmentNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsWrittenOffFlag] [bit] NOT NULL,
	[IsRefundedFlag] [bit] NOT NULL,
	[RefundedSalesOrderKey] [int] NOT NULL,
	[RefundedSalesOrderSSID] [uniqueidentifier] NOT NULL,
	[RowIsCurrent] [tinyint] NOT NULL,
	[RowStartDate] [datetime] NOT NULL,
	[RowEndDate] [datetime] NOT NULL,
	[RowChangeReason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[RowIsInferred] [tinyint] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IncomingRequestID] [int] NULL,
 CONSTRAINT [PK_DimSalesOrder] PRIMARY KEY CLUSTERED
(
	[SalesOrderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
