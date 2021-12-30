/* CreateDate: 05/05/2020 17:42:50.193 , ModifyDate: 05/05/2020 17:43:10.417 */
GO
CREATE TABLE [dbo].[datHairSystemInventoryTransaction](
	[HairSystemInventoryTransactionID] [int] NOT NULL,
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
	[IsScannedEntry] [bit] NOT NULL,
 CONSTRAINT [PK_datHairSystemInventoryTransaction] PRIMARY KEY CLUSTERED
(
	[HairSystemInventoryTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
