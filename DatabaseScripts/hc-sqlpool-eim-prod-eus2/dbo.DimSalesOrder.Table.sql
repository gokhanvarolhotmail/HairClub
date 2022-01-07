/****** Object:  Table [dbo].[DimSalesOrder]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesOrder]
(
	[SalesOrderKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderID] [uniqueidentifier] NULL,
	[TenderTransactionNumber_Temp] [int] NULL,
	[TicketNumber_Temp] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterKey] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[SalesOrderTypeKey] [int] NULL,
	[SalesOrderTypeID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientID] [uniqueidentifier] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipID] [uniqueidentifier] NULL,
	[OrderDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](50) NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[EmployeeKey] [int] NULL,
	[EmployeeID] [uniqueidentifier] NULL,
	[FulfillmentNumber] [nvarchar](15) NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderKey] [int] NULL,
	[RefundedSalesOrderID] [uniqueidentifier] NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IncomingRequestID] [int] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[SalesOrderID] ASC
	)
)
GO
