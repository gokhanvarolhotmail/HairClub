/* CreateDate: 10/04/2010 12:08:45.410 , ModifyDate: 12/03/2021 10:24:48.640 */
GO
CREATE TABLE [dbo].[lkpPurchaseOrderStatus](
	[PurchaseOrderStatusID] [int] NOT NULL,
	[PurchaseOrderStatusSortOrder] [int] NOT NULL,
	[PurchaseOrderStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PurchaseOrderStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpPurchaseOrderStatus] PRIMARY KEY CLUSTERED
(
	[PurchaseOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPurchaseOrderStatus] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
