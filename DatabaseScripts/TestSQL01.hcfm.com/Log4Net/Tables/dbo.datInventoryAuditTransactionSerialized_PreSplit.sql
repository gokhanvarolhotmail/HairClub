/* CreateDate: 07/08/2019 12:57:21.580 , ModifyDate: 07/08/2019 12:57:21.580 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datInventoryAuditTransactionSerialized_PreSplit](
	[InventoryAuditTransactionSerializedID] [int] NOT NULL,
	[InventoryAuditTransactionID] [int] NOT NULL,
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
	[ScannedInventoryAuditBatchID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DeviceAddedAfterSnapshotTaken] [bit] NOT NULL,
	[InventoryAdjustmentIdAtTimeOfSnapshot] [int] NULL,
	[IsExcludedFromCorrections] [bit] NULL,
 CONSTRAINT [PK_datInventoryAuditTransactionSerialized] PRIMARY KEY CLUSTERED
(
	[InventoryAuditTransactionSerializedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
