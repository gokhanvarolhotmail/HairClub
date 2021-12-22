/* CreateDate: 01/27/2021 11:22:42.623 , ModifyDate: 01/27/2021 11:22:42.623 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
GO
