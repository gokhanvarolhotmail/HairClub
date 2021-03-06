/****** Object:  Table [ODS].[CNCT_datSalesOrder]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datSalesOrder]
(
	[SalesOrderGUID] [varchar](8000) NULL,
	[TenderTransactionNumber_Temp] [int] NULL,
	[TicketNumber_Temp] [int] NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[SalesOrderTypeID] [int] NULL,
	[ClientGUID] [varchar](8000) NULL,
	[ClientMembershipGUID] [varchar](8000) NULL,
	[AppointmentGUID] [varchar](8000) NULL,
	[HairSystemOrderGUID] [varchar](8000) NULL,
	[OrderDate] [datetime2](7) NULL,
	[InvoiceNumber] [varchar](8000) NULL,
	[IsTaxExemptFlag] [bit] NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[RegisterCloseGUID] [varchar](8000) NULL,
	[EmployeeGUID] [varchar](8000) NULL,
	[FulfillmentNumber] [varchar](8000) NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderGUID] [varchar](8000) NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[ParentSalesOrderGUID] [varchar](8000) NULL,
	[IsSurgeryReversalFlag] [bit] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[cashier_temp] [varchar](8000) NULL,
	[ctrOrderDate] [datetime2](7) NULL,
	[CenterFeeBatchGUID] [varchar](8000) NULL,
	[CenterDeclineBatchGUID] [varchar](8000) NULL,
	[RegisterID] [int] NULL,
	[EndOfDayGUID] [varchar](8000) NULL,
	[IncomingRequestID] [int] NULL,
	[WriteOffSalesOrderGUID] [varchar](8000) NULL,
	[NSFSalesOrderGUID] [varchar](8000) NULL,
	[ChargeBackSalesOrderGUID] [varchar](8000) NULL,
	[ChargebackReasonID] [int] NULL,
	[InterCompanyTransactionID] [int] NULL,
	[WriteOffReasonDescription] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
