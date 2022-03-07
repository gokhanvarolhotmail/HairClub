/* CreateDate: 10/04/2010 12:08:45.953 , ModifyDate: 03/04/2022 16:09:12.507 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanApplyFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanTransferFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanEditFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanCancelFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [IsPreallocationFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanRedoFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanRepairFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [ShowInHistoryFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [CanAddToStockFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  CONSTRAINT [DF_lkpHairSystemOrderStatus_IncludeInMembershipCountFlag]  DEFAULT ((0)) FOR [IncludeInMembershipCountFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  CONSTRAINT [DF_lkpHairSystemOrderStatus_CanRequestCredit]  DEFAULT ((0)) FOR [CanRequestCreditFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [IncludeInInventorySnapshotFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderStatus] ADD  DEFAULT ((0)) FOR [IsInTransitFlag]
GO
