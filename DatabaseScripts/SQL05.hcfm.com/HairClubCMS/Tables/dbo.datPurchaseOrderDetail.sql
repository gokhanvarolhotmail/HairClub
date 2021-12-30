/* CreateDate: 05/05/2020 17:42:50.810 , ModifyDate: 05/05/2020 18:34:12.653 */
GO
CREATE TABLE [dbo].[datPurchaseOrderDetail](
	[PurchaseOrderDetailGUID] [uniqueidentifier] NOT NULL,
	[PurchaseOrderGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[HairSystemAllocationFilterID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_datPurchaseOrderDetail] PRIMARY KEY CLUSTERED
(
	[PurchaseOrderDetailGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrderDetail_HairSystemOrderGUID_INCL] ON [dbo].[datPurchaseOrderDetail]
(
	[HairSystemOrderGUID] ASC
)
INCLUDE([PurchaseOrderGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
