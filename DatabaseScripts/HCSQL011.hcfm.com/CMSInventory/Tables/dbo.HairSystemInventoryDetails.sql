/* CreateDate: 03/30/2011 09:42:32.283 , ModifyDate: 03/31/2016 05:17:59.363 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HairSystemInventoryDetails](
	[InventoryDetailsID] [uniqueidentifier] NULL,
	[InventoryID] [uniqueidentifier] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[HairSystemOrderNumber] [int] NULL,
	[HairSystemOrderStatusID] [int] NULL,
	[InTransit] [bit] NULL,
	[CostContract] [money] NULL,
	[CostActual] [money] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[ClientIdentifier] [int] NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembership] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScannedDate] [datetime] NULL,
	[ScannedUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScannedCenterID] [int] NULL,
	[Exception] [bit] NULL,
	[HairSystemOrderDate] [datetime] NULL,
	[HairSystemContractName] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemFactory] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[HairSystemOrderStatus] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientCenterID] [int] NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_HairSystemInventoryDetails] ON [dbo].[HairSystemInventoryDetails]
(
	[HairSystemOrderNumber] ASC,
	[InventoryDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_HairSystemInventoryDetails_HairSystemOrderNumber] ON [dbo].[HairSystemInventoryDetails]
(
	[HairSystemOrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_InventoryID_ScannedDate_ScannedUser] ON [dbo].[HairSystemInventoryDetails]
(
	[InventoryID] ASC
)
INCLUDE([ScannedDate],[ScannedUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
