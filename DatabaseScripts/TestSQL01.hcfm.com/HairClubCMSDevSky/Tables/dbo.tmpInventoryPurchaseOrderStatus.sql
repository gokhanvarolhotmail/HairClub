/* CreateDate: 05/29/2018 11:03:37.990 , ModifyDate: 11/29/2018 22:40:44.740 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpInventoryPurchaseOrderStatus](
	[PONumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderId] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderStatus] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShipmentStatus] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EIGlobalStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SSISRunInstance] [datetime] NULL,
	[IsError] [bit] NULL,
	[TrackingNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Carrier] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
