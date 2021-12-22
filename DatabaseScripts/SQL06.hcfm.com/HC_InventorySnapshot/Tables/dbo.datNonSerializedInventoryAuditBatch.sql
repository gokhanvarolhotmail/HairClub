CREATE TABLE [dbo].[datNonSerializedInventoryAuditBatch](
	[NonSerializedInventoryAuditBatchID] [int] IDENTITY(1,1) NOT NULL,
	[NonSerializedInventoryAuditSnapshotID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[InventoryAuditBatchStatusID] [int] NOT NULL,
	[CompleteDate] [datetime] NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[IsReviewCompleted] [bit] NOT NULL,
	[ReviewCompleteDate] [datetime] NULL,
	[ReviewCompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[IsAdjustmentCompleted] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
