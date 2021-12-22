CREATE TABLE [dbo].[tmpSalesCodeInventory](
	[SalesCodeCenterInventoryID] [float] NULL,
	[SalesCodeCenterID] [float] NULL,
	[QuantityOnHand] [float] NULL,
	[QuantityPar] [float] NULL,
	[IsActive] [float] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
