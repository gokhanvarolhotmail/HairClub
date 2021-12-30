/* CreateDate: 12/07/2020 16:29:29.900 , ModifyDate: 12/07/2020 16:29:29.900 */
GO
CREATE TABLE [dbo].[datHairSystemInventorySnapshot](
	[HairSystemInventorySnapshotID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SnapshotDate] [datetime] NOT NULL,
	[SnapshotLabel] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsAdjustmentCompleted] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
