/* CreateDate: 10/31/2019 20:53:49.520 , ModifyDate: 11/01/2019 09:57:49.003 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderStatus](
	[HairSystemOrderStatusID] [int] NOT NULL,
	[HairSystemOrderStatusSortOrder] [int] NOT NULL,
	[HairSystemOrderStatusDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CanApplyFlag] [bit] NOT NULL,
	[CanTransferFlag] [bit] NOT NULL,
	[CanEditFlag] [bit] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanCancelFlag] [bit] NOT NULL,
	[IsPreallocationFlag] [bit] NOT NULL,
	[CanRedoFlag] [bit] NOT NULL,
	[CanRepairFlag] [bit] NOT NULL,
	[ShowInHistoryFlag] [bit] NOT NULL,
	[CanAddToStockFlag] [bit] NOT NULL,
	[IncludeInMembershipCountFlag] [bit] NOT NULL,
	[CanRequestCreditFlag] [bit] NOT NULL,
	[IncludeInInventorySnapshotFlag] [bit] NOT NULL,
	[IsInTransitFlag] [bit] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
