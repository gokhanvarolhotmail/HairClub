/* CreateDate: 05/05/2020 17:42:47.910 , ModifyDate: 05/05/2020 17:43:07.210 */
GO
CREATE TABLE [dbo].[datAccountReceivable](
	[AccountReceivableID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[SalesOrderGUID] [uniqueidentifier] NOT NULL,
	[CenterFeeBatchGUID] [uniqueidentifier] NULL,
	[Amount] [money] NOT NULL,
	[IsClosed] [bit] NOT NULL,
	[AccountReceivableTypeID] [int] NOT NULL,
	[RemainingBalance] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[CenterDeclineBatchGUID] [uniqueidentifier] NULL,
	[RefundedSalesOrderGuid] [uniqueidentifier] NULL,
	[WriteOffSalesOrderGUID] [uniqueidentifier] NULL,
	[NSFSalesOrderGUID] [uniqueidentifier] NULL,
	[ChargeBackSalesOrderGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_datAccountReceivable] PRIMARY KEY CLUSTERED
(
	[AccountReceivableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
