/* CreateDate: 09/23/2019 12:30:52.747 , ModifyDate: 04/23/2020 11:24:49.423 */
GO
CREATE TABLE [dbo].[datNonSerializedInventoryAuditTransaction](
	[NonSerializedInventoryAuditTransactionID] [int] IDENTITY(1,1) NOT NULL,
	[NonSerializedInventoryAuditBatchID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[QuantityExpected] [int] NOT NULL,
	[IsExcludedFromCorrections] [bit] NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datNonSerializedInventoryAuditTransaction] PRIMARY KEY CLUSTERED
(
	[NonSerializedInventoryAuditTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNonSerializedInventoryAuditTransaction_NonSerializedInventoryAuditBatchID_IsExcludedFromCorrections] ON [dbo].[datNonSerializedInventoryAuditTransaction]
(
	[NonSerializedInventoryAuditBatchID] ASC,
	[IsExcludedFromCorrections] ASC
)
INCLUDE([SalesCodeID],[QuantityExpected]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditTransaction_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransaction] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditTransaction_cfgSalesCode]
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransaction]  WITH CHECK ADD  CONSTRAINT [FK_datNonSerializedInventoryAuditTransaction_datNonSerializedInventoryAuditBatch] FOREIGN KEY([NonSerializedInventoryAuditBatchID])
REFERENCES [dbo].[datNonSerializedInventoryAuditBatch] ([NonSerializedInventoryAuditBatchID])
GO
ALTER TABLE [dbo].[datNonSerializedInventoryAuditTransaction] CHECK CONSTRAINT [FK_datNonSerializedInventoryAuditTransaction_datNonSerializedInventoryAuditBatch]
GO
