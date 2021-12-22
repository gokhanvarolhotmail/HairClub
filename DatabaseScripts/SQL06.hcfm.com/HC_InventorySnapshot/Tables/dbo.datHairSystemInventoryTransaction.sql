/* CreateDate: 12/07/2020 16:29:29.900 , ModifyDate: 12/07/2020 16:29:29.920 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datHairSystemInventoryTransaction](
	[HairSystemInventoryTransactionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemInventoryBatchID] [int] NOT NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NOT NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderStatusID] [int] NOT NULL,
	[IsInTransit] [bit] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[ClientHomeCenterID] [int] NOT NULL,
	[ScannedDate] [datetime] NULL,
	[ScannedEmployeeGUID] [uniqueidentifier] NULL,
	[ScannedCenterID] [int] NULL,
	[ScannedHairSystemInventoryBatchID] [int] NULL,
	[IsExcludedFromCorrections] [bit] NOT NULL,
	[ExclusionReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[IsScannedEntry] [bit] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datHairSystemInventoryTransaction] ADD  DEFAULT ((0)) FOR [IsScannedEntry]
GO
