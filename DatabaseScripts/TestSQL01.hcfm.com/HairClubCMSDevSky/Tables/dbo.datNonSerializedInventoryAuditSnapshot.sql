/* CreateDate: 09/23/2019 12:30:52.660 , ModifyDate: 09/23/2019 12:30:52.690 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datNonSerializedInventoryAuditSnapshot] PRIMARY KEY CLUSTERED
(
	[NonSerializedInventoryAuditSnapshotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
