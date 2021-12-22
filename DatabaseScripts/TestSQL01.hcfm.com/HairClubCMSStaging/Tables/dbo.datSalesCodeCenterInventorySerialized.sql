/* CreateDate: 05/28/2018 22:15:34.540 , ModifyDate: 11/14/2018 22:39:56.090 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datSalesCodeCenterInventorySerialized](
	[SalesCodeCenterInventorySerializedID] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeCenterInventoryID] [int] NOT NULL,
	[SerialNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SerializedInventoryStatusID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSalesCodeCenterInventorySerialized] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterInventorySerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datSalesCodeCenterInventorySerialized_SerialNumber] UNIQUE NONCLUSTERED
(
	[SerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datSalesCodeCenterInventorySerialized_SerialNumber] ON [dbo].[datSalesCodeCenterInventorySerialized]
(
	[SerialNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventorySerialized]  WITH CHECK ADD  CONSTRAINT [FK_datSalesCodeCenterInventorySerialized_datSalesCodeCenterInventory] FOREIGN KEY([SalesCodeCenterInventoryID])
REFERENCES [dbo].[datSalesCodeCenterInventory] ([SalesCodeCenterInventoryID])
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventorySerialized] CHECK CONSTRAINT [FK_datSalesCodeCenterInventorySerialized_datSalesCodeCenterInventory]
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventorySerialized]  WITH CHECK ADD  CONSTRAINT [FK_datSalesCodeCenterInventorySerialized_lkpSerializedInventoryStatus] FOREIGN KEY([SerializedInventoryStatusID])
REFERENCES [dbo].[lkpSerializedInventoryStatus] ([SerializedInventoryStatusID])
GO
ALTER TABLE [dbo].[datSalesCodeCenterInventorySerialized] CHECK CONSTRAINT [FK_datSalesCodeCenterInventorySerialized_lkpSerializedInventoryStatus]
GO
