/* CreateDate: 12/07/2020 16:29:29.897 , ModifyDate: 12/07/2020 16:29:29.897 */
GO
CREATE TABLE [dbo].[datHairSystemInventoryBatch](
	[HairSystemInventoryBatchID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemInventorySnapshotID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[HairSystemInventoryBatchStatusID] [int] NOT NULL,
	[ScanCompleteDate] [datetime] NULL,
	[ScanCompleteEmployeeGUID] [uniqueidentifier] NULL,
	[IsAdjustmentCompleted] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
