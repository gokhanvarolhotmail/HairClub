/* CreateDate: 05/05/2020 17:42:46.240 , ModifyDate: 05/05/2020 18:41:07.640 */
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
	[UpdateStamp] [timestamp] NULL,
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
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpHairSystemOrderStatus] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
