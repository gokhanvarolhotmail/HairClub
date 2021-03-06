/* CreateDate: 05/05/2020 17:42:50.673 , ModifyDate: 05/05/2020 17:43:10.993 */
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
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpPurchaseOrderType] PRIMARY KEY CLUSTERED
(
	[PurchaseOrderTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
