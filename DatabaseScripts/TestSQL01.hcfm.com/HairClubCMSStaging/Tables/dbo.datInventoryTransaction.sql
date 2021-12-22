/* CreateDate: 10/27/2008 13:46:44.447 , ModifyDate: 05/26/2020 10:49:42.320 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datInventoryTransaction](
	[InventoryTransactionGUID] [uniqueidentifier] NOT NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[SalesCodeCenterID] [int] NULL,
	[InventoryTransactionTypeID] [int] NULL,
	[InventoryTransactionDate] [datetime] NULL,
	[QuantityAdjustment] [int] NULL,
	[ResetQuantityFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemHoldReasonID] [int] NULL,
 CONSTRAINT [PK_datInventoryTransaction] PRIMARY KEY CLUSTERED
(
	[InventoryTransactionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryTransaction] ADD  CONSTRAINT [DF_datInventoryTransaction_ResetQuantityFlag]  DEFAULT ((0)) FOR [ResetQuantityFlag]
GO
ALTER TABLE [dbo].[datInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransaction_cfgSalesCodeCenter] FOREIGN KEY([SalesCodeCenterID])
REFERENCES [dbo].[cfgSalesCodeCenter] ([SalesCodeCenterID])
GO
ALTER TABLE [dbo].[datInventoryTransaction] CHECK CONSTRAINT [FK_datInventoryTransaction_cfgSalesCodeCenter]
GO
ALTER TABLE [dbo].[datInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransaction_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datInventoryTransaction] CHECK CONSTRAINT [FK_datInventoryTransaction_datEmployee]
GO
ALTER TABLE [dbo].[datInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransaction_lkpHairSystemHoldReason] FOREIGN KEY([HairSystemHoldReasonID])
REFERENCES [dbo].[lkpHairSystemHoldReason] ([HairSystemHoldReasonID])
GO
ALTER TABLE [dbo].[datInventoryTransaction] CHECK CONSTRAINT [FK_datInventoryTransaction_lkpHairSystemHoldReason]
GO
ALTER TABLE [dbo].[datInventoryTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryTransaction_lkpInventoryTransactionType] FOREIGN KEY([InventoryTransactionTypeID])
REFERENCES [dbo].[lkpInventoryTransactionType] ([InventoryTransactionTypeID])
GO
ALTER TABLE [dbo].[datInventoryTransaction] CHECK CONSTRAINT [FK_datInventoryTransaction_lkpInventoryTransactionType]
GO
