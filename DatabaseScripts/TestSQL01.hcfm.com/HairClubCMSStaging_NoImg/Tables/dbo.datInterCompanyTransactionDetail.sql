/* CreateDate: 02/06/2014 20:26:42.590 , ModifyDate: 12/03/2021 10:24:48.533 */
GO
CREATE TABLE [dbo].[datInterCompanyTransactionDetail](
	[InterCompanyTransactionDetailId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[InterCompanyTransactionId] [int] NOT NULL,
	[SalesOrderDetailGUID] [uniqueidentifier] NOT NULL,
	[SalesCodeId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[TotalCost]  AS ([Price]*[Quantity]),
	[AmountCollected] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datInterCompanyTransactionDetail] PRIMARY KEY CLUSTERED
(
	[InterCompanyTransactionDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInterCompanyTransactionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransactionDetail_cfgSalesCode] FOREIGN KEY([SalesCodeId])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datInterCompanyTransactionDetail] CHECK CONSTRAINT [FK_datInterCompanyTransactionDetail_cfgSalesCode]
GO
ALTER TABLE [dbo].[datInterCompanyTransactionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransactionDetail_datInterCompanyTransaction] FOREIGN KEY([InterCompanyTransactionId])
REFERENCES [dbo].[datInterCompanyTransaction] ([InterCompanyTransactionId])
GO
ALTER TABLE [dbo].[datInterCompanyTransactionDetail] CHECK CONSTRAINT [FK_datInterCompanyTransactionDetail_datInterCompanyTransaction]
GO
ALTER TABLE [dbo].[datInterCompanyTransactionDetail]  WITH NOCHECK ADD  CONSTRAINT [FK_datInterCompanyTransactionDetail_datSalesOrderDetail] FOREIGN KEY([SalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datInterCompanyTransactionDetail] CHECK CONSTRAINT [FK_datInterCompanyTransactionDetail_datSalesOrderDetail]
GO
