/* CreateDate: 11/12/2014 09:44:37.153 , ModifyDate: 11/12/2014 09:44:37.153 */
GO
CREATE TABLE [dbo].[ARTransOriginalFixedNegARCreditRefund](
	[AccountReceivableID] [int] NULL,
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterFeeBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [money] NULL,
	[IsClosed] [bit] NULL,
	[AccountReceivableTypeID] [int] NULL,
	[RemainingBalance] [money] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterDeclineBatchGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RefundSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WriteOffSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NSFSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ChareBackSalesOrderGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionTaken] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
