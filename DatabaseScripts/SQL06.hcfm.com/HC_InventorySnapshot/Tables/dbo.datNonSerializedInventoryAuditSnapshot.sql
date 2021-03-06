/* CreateDate: 12/07/2020 16:29:29.907 , ModifyDate: 12/07/2020 16:29:29.907 */
GO
CREATE TABLE [dbo].[datNonSerializedInventoryAuditSnapshot](
	[NonSerializedInventoryAuditSnapshotID] [int] IDENTITY(1,1) NOT NULL,
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
