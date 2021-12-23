/* CreateDate: 05/28/2018 22:19:21.543 , ModifyDate: 12/16/2019 08:35:00.243 */
GO
CREATE TABLE [dbo].[datSalesOrderDetailSerialized](
	[SalesOrderDetailSerializedID] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderDetailGUID] [uniqueidentifier] NOT NULL,
	[SalesCodeCenterInventorySerializedID] [int] NOT NULL,
	[IsScannedEntry] [bit] NOT NULL,
	[IsReturned] [bit] NOT NULL,
	[RefundedSalesOrderDetailSerializedID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsReturnedItemAvailableForResale] [bit] NULL,
 CONSTRAINT [PK_datSalesOrderDetailSerialized] PRIMARY KEY CLUSTERED
(
	[SalesOrderDetailSerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesOrderDetailSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSalesOrderDetailSerialized_datSalesCodeCenterInventorySerialized] FOREIGN KEY([SalesCodeCenterInventorySerializedID])
REFERENCES [dbo].[datSalesCodeCenterInventorySerialized] ([SalesCodeCenterInventorySerializedID])
GO
ALTER TABLE [dbo].[datSalesOrderDetailSerialized] CHECK CONSTRAINT [FK_datSalesOrderDetailSerialized_datSalesCodeCenterInventorySerialized]
GO
ALTER TABLE [dbo].[datSalesOrderDetailSerialized]  WITH NOCHECK ADD  CONSTRAINT [FK_datSalesOrderDetailSerialized_datSalesOrderDetail] FOREIGN KEY([SalesOrderDetailGUID])
REFERENCES [dbo].[datSalesOrderDetail] ([SalesOrderDetailGUID])
GO
ALTER TABLE [dbo].[datSalesOrderDetailSerialized] CHECK CONSTRAINT [FK_datSalesOrderDetailSerialized_datSalesOrderDetail]
GO
