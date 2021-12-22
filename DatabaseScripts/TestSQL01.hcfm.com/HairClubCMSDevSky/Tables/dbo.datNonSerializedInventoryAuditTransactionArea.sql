/* CreateDate: 09/23/2019 12:30:52.780 , ModifyDate: 04/23/2020 11:24:50.560 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datNonSerializedInventoryAuditTransactionArea](
	[NonSerializedInventoryAuditTransactionAreaID] [int] IDENTITY(1,1) NOT NULL,
	[NonSerializedInventoryAuditTransactionID] [int] NOT NULL,
	[InventoryAreaID] [int] NOT NULL,
	[QuantityEntered] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datNonSerializedInventoryAuditTransactionArea] PRIMARY KEY CLUSTERED
(
	[NonSerializedInventoryAuditTransactionAreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNonSerializedInventoryAuditTransactionArea_NonSerializedInventoryAuditTransactionID] ON [dbo].[datNonSerializedInventoryAuditTransactionArea]
(
	[NonSerializedInventoryAuditTransactionID] ASC
)
INCLUDE([QuantityEntered]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransactionArea]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditTransactionArea_datNonSerializedInventoryAuditTransaction] FOREIGN KEY([NonSerializedInventoryAuditTransactionID])
REFERENCES [dbo].[datNonSerializedInventoryAuditTransaction] ([NonSerializedInventoryAuditTransactionID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransactionArea] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditTransactionArea_datNonSerializedInventoryAuditTransaction]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransactionArea]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditTransactionArea_lkpInventoryArea] FOREIGN KEY([InventoryAreaID])
REFERENCES [dbo].[lkpInventoryArea] ([InventoryAreaID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransactionArea] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditTransactionArea_lkpInventoryArea]
GO
