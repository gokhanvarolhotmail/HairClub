/* CreateDate: 11/01/2019 09:34:53.427 , ModifyDate: 11/01/2019 09:34:53.537 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [_dta_index_datPurchaseOrderDetail_HairSystemOrderGuid_PurchaseOrderGuid] ON [dbo].[datPurchaseOrderDetail]
(
	[HairSystemOrderGUID] ASC,
	[PurchaseOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrderDetail_HairSYstemOrderGUID] ON [dbo].[datPurchaseOrderDetail]
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrderDetail_Misc] ON [dbo].[datPurchaseOrderDetail]
(
	[PurchaseOrderGUID] ASC,
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datPurchaseOrderDetail_PurchaseOrderGUID] ON [dbo].[datPurchaseOrderDetail]
(
	[PurchaseOrderGUID] ASC
)
INCLUDE([HairSystemOrderGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datPurchaseOrderDetail_HairSystemOrderGUID] ON [dbo].[datPurchaseOrderDetail]
(
	[HairSystemOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
