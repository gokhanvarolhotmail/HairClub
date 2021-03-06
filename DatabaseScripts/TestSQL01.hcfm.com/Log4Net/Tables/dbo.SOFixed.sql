/* CreateDate: 03/05/2014 16:36:50.387 , ModifyDate: 03/05/2014 16:36:50.387 */
GO
CREATE TABLE [dbo].[SOFixed](
	[SalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TenderTransactionNumber_Temp] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TicketNumber_Temp] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [float] NULL,
	[ClientHomeCenterID] [float] NULL,
	[SalesOrderTypeID] [float] NULL,
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembershipGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderDate] [datetime] NULL,
	[InvoiceNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTaxExemptFlag] [float] NULL,
	[IsVoidedFlag] [float] NULL,
	[IsClosedFlag] [float] NULL,
	[RegisterCloseGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FulfillmentNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsWrittenOffFlag] [float] NULL,
	[IsRefundedFlag] [float] NULL,
	[RefundedSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSurgeryReversalFlag] [float] NULL,
	[IsGuaranteeFlag] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cashier_temp] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ctrOrderDate] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterFeeBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterDeclineBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegisterID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EndOfDayGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IncomingRequestID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WriteOffSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NSFSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ChargeBackSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ChargebackReasonID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InterCompanyTransactionID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
