/* CreateDate: 11/13/2014 14:00:43.460 , ModifyDate: 11/13/2014 14:00:43.460 */
GO
CREATE TABLE [dbo].[ARFix_WriteMissingAutoCCPmtRefundToAR](
	[ClientGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterFeeBatchGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [money] NULL,
	[IsClosed] [bit] NULL,
	[AccountReceivableTypeID] [int] NULL,
	[RemainingBalance] [money] NULL,
	[CenterDeclineBatchGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefundedSalesOrderGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WriteOffSalesOrderGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NSFSalesOrderGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ChargeBackSalesOrderGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionTaken] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogCreateDate] [datetime] NULL,
	[TFSUser] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
