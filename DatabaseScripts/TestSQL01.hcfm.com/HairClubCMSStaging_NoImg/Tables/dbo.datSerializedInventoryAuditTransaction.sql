/* CreateDate: 09/23/2019 12:30:41.953 , ModifyDate: 12/03/2021 10:24:48.667 */
GO
CREATE TABLE [dbo].[datSerializedInventoryAuditTransaction](
	[SerializedInventoryAuditTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[SerializedInventoryAuditBatchID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[QuantityExpected] [int] NOT NULL,
	[IsExcludedFromCorrections] [bit] NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datSerializedInventoryAuditTransaction] PRIMARY KEY CLUSTERED
(
	[SerializedInventoryAuditTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransaction_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransaction] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransaction_cfgSalesCode]
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransaction]  WITH NOCHECK ADD  CONSTRAINT [FK_datSerializedInventoryAuditTransaction_datSerializedInventoryAuditBatch] FOREIGN KEY([SerializedInventoryAuditBatchID])
REFERENCES [dbo].[datSerializedInventoryAuditBatch] ([SerializedInventoryAuditBatchID])
GO
ALTER TABLE [dbo].[datSerializedInventoryAuditTransaction] CHECK CONSTRAINT [FK_datSerializedInventoryAuditTransaction_datSerializedInventoryAuditBatch]
GO
