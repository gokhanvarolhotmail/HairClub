/* CreateDate: 05/05/2020 17:42:55.767 , ModifyDate: 05/05/2020 17:43:17.177 */
GO
CREATE TABLE [dbo].[datSerializedInventoryAuditTransactionSerialized](
	[SerializedInventoryAuditTransactionSerializedID] [int] NOT NULL,
	[SerializedInventoryAuditTransactionID] [int] NOT NULL,
	[SerialNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsInTransit] [bit] NOT NULL,
	[SerializedInventoryStatusID] [int] NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InventoryNotScannedReasonID] [int] NULL,
	[InventoryNotScannedNote] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsScannedEntry] [bit] NULL,
	[ScannedDate] [datetime] NULL,
	[ScannedEmployeeGUID] [uniqueidentifier] NULL,
	[ScannedCenterID] [int] NULL,
	[ScannedSerializedInventoryAuditBatchID] [int] NULL,
	[DeviceAddedAfterSnapshotTaken] [bit] NOT NULL,
	[InventoryAdjustmentIdAtTimeOfSnapshot] [int] NULL,
	[IsExcludedFromCorrections] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_datSerializedInventoryAuditTransactionSerialized] ON [dbo].[datSerializedInventoryAuditTransactionSerialized]
(
	[SerializedInventoryAuditTransactionSerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
