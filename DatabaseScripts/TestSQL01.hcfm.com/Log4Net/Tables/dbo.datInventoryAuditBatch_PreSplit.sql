/* CreateDate: 07/08/2019 12:55:59.210 , ModifyDate: 07/08/2019 12:55:59.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datInventoryAuditBatch_PreSplit](
	[InventoryAuditBatchID] [int] NOT NULL,
	[InventoryAuditSnapshotID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[InventoryAuditBatchStatusID] [int] NOT NULL,
	[CompleteDate] [datetime] NULL,
	[CompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[IsAdjustmentCompleted] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsSerializedReviewCompleted] [bit] NOT NULL,
	[SerializedReviewCompleteDate] [datetime] NULL,
	[SerializedReviewCompletedByEmployeeGUID] [uniqueidentifier] NULL,
	[IsNonSerializedReviewCompleted] [bit] NOT NULL,
	[NonSerializedReviewCompleteDate] [datetime] NULL,
	[NonSerializedReviewCompletedByEmployeeGUID] [uniqueidentifier] NULL,
 CONSTRAINT [PK_datInventoryAuditBatch] PRIMARY KEY CLUSTERED
(
	[InventoryAuditBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
