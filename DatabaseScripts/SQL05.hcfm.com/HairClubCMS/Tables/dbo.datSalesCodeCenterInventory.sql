/* CreateDate: 05/05/2020 17:42:56.090 , ModifyDate: 09/13/2021 19:14:14.777 */
GO
CREATE TABLE [dbo].[datSalesCodeCenterInventory](
	[SalesCodeCenterInventoryID] [int] NOT NULL,
	[SalesCodeCenterID] [int] NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[QuantityPar] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_datSalesCodeCenterInventory] ON [dbo].[datSalesCodeCenterInventory]
(
	[SalesCodeCenterInventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_datSalesCodeCenterInventory_SalesCodeCenterID] ON [dbo].[datSalesCodeCenterInventory]
(
	[SalesCodeCenterID] ASC
)
INCLUDE([QuantityOnHand],[QuantityPar]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
