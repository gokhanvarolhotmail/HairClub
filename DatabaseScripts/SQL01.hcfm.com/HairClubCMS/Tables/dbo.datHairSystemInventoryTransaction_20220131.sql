/* CreateDate: 01/31/2022 14:49:47.050 , ModifyDate: 01/31/2022 14:49:47.050 */
GO
CREATE TABLE [dbo].[datHairSystemInventoryTransaction_20220131](
	[HairSystemInventoryTransactionID] [int] IDENTITY(1,1) NOT NULL,
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
