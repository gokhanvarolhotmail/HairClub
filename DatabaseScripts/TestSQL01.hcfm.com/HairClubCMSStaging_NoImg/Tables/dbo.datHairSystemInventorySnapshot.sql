/* CreateDate: 05/31/2016 07:49:04.883 , ModifyDate: 12/03/2021 10:24:48.723 */
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
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datHairSystemInventorySnapshot] PRIMARY KEY CLUSTERED
(
	[HairSystemInventorySnapshotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
