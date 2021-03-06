/* CreateDate: 10/31/2019 20:53:49.550 , ModifyDate: 11/01/2019 09:57:49.007 */
GO
CREATE TABLE [dbo].[lkpPurchaseOrderType](
	[PurchaseOrderTypeID] [int] NOT NULL,
	[PurchaseOrderTypeSortOrder] [int] NOT NULL,
	[PurchaseOrderTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PurchaseOrderTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
