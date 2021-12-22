CREATE TABLE [dbo].[datSalesCodeCenterInventory](
	[SalesCodeCenterInventoryID] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeCenterID] [int] NOT NULL,
	[QuantityOnHand] [int] NOT NULL,
	[QuantityPar] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSalesCodeCenterInventory] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterInventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_datSalesCodeCenterInventory_SalesCodeCenterID] ON [dbo].[datSalesCodeCenterInventory]
(
	[SalesCodeCenterID] ASC
)
INCLUDE([QuantityOnHand],[QuantityPar]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventory]  WITH CHECK ADD  CONSTRAINT [FK_datSalesCodeCenterInventory_cfgSalesCodeCenter] FOREIGN KEY([SalesCodeCenterID])
REFERENCES [dbo].[cfgSalesCodeCenter] ([SalesCodeCenterID])
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventory] CHECK CONSTRAINT [FK_datSalesCodeCenterInventory_cfgSalesCodeCenter]
