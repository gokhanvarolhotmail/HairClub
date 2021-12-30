/* CreateDate: 05/05/2020 17:42:50.147 , ModifyDate: 05/05/2020 17:43:10.230 */
GO
CREATE TABLE [dbo].[datHairSystemInventoryBatch](
	[HairSystemInventoryBatchID] [int] NOT NULL,
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
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datHairSystemInventoryBatch] PRIMARY KEY CLUSTERED
(
	[HairSystemInventoryBatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
