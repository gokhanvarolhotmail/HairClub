/* CreateDate: 05/28/2018 22:15:34.580 , ModifyDate: 09/23/2019 12:34:03.313 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datInventoryAdjustment](
	[InventoryAdjustmentID] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NOT NULL,
	[TransferToCenterID] [int] NULL,
	[TransferFromCenterID] [int] NULL,
	[DistributorPurchaseOrderID] [int] NULL,
	[InventoryAdjustmentTypeID] [int] NOT NULL,
	[InventoryAdjustmentDate] [datetime] NOT NULL,
	[Note] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SerializedInventoryAuditBatchID] [int] NULL,
	[NonSerializedInventoryAuditBatchID] [int] NULL,
 CONSTRAINT [PK_datInventoryAdjustment] PRIMARY KEY CLUSTERED
(
	[InventoryAdjustmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_cfgCenter]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_cfgCenter2] FOREIGN KEY([TransferToCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_cfgCenter2]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_cfgCenter3] FOREIGN KEY([TransferFromCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_cfgCenter3]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_datDistributorPurchaseOrder] FOREIGN KEY([DistributorPurchaseOrderID])
REFERENCES [dbo].[datDistributorPurchaseOrder] ([DistributorPurchaseOrderID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_datDistributorPurchaseOrder]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_datEmployee]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_datNonSerializedInventoryAuditBatch] FOREIGN KEY([NonSerializedInventoryAuditBatchID])
REFERENCES [dbo].[datNonSerializedInventoryAuditBatch] ([NonSerializedInventoryAuditBatchID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_datNonSerializedInventoryAuditBatch]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_datSalesOrder]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_datSerializedInventoryAuditBatch] FOREIGN KEY([SerializedInventoryAuditBatchID])
REFERENCES [dbo].[datSerializedInventoryAuditBatch] ([SerializedInventoryAuditBatchID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_datSerializedInventoryAuditBatch]
GO
ALTER TABLE [dbo].[datInventoryAdjustment]  WITH CHECK ADD  CONSTRAINT [FK_datInventoryAdjustment_lkpInventoryAdjustmentType] FOREIGN KEY([InventoryAdjustmentTypeID])
REFERENCES [dbo].[lkpInventoryAdjustmentType] ([InventoryAdjustmentTypeID])
GO
ALTER TABLE [dbo].[datInventoryAdjustment] CHECK CONSTRAINT [FK_datInventoryAdjustment_lkpInventoryAdjustmentType]
GO
