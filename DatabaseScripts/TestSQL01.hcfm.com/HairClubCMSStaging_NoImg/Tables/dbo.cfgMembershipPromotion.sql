/* CreateDate: 02/18/2013 06:49:02.310 , ModifyDate: 03/04/2022 16:09:12.543 */
GO
CREATE TABLE [dbo].[cfgMembershipPromotion](
	[MembershipPromotionID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[MembershipPromotionSortOrder] [int] NOT NULL,
	[MembershipPromotionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipPromotionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipPromotionTypeID] [int] NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Amount] [decimal](6, 2) NOT NULL,
	[RevenueGroupID] [int] NULL,
	[BusinessSegmentID] [int] NULL,
	[AdditionalSystems] [int] NOT NULL,
	[AdditionalServices] [int] NOT NULL,
	[AdditionalSolutions] [int] NOT NULL,
	[AdditionalProductKits] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[AdditionalHCSL] [int] NOT NULL,
	[AdditionalStrands] [int] NOT NULL,
	[MembershipPromotionGroupID] [int] NULL,
	[MembershipPromotionAdjustmentTypeID] [int] NULL,
 CONSTRAINT [PK_lkpMembershipPromotion] PRIMARY KEY CLUSTERED
(
	[MembershipPromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] ADD  DEFAULT ((0)) FOR [AdditionalHCSL]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] ADD  DEFAULT ((0)) FOR [AdditionalStrands]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipPromotion_lkpBusinessSegment] FOREIGN KEY([BusinessSegmentID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] CHECK CONSTRAINT [FK_cfgMembershipPromotion_lkpBusinessSegment]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipPromotion_lkpMembershipPromotion] FOREIGN KEY([MembershipPromotionTypeID])
REFERENCES [dbo].[lkpMembershipPromotionType] ([MembershipPromotionTypeID])
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] CHECK CONSTRAINT [FK_cfgMembershipPromotion_lkpMembershipPromotion]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipPromotion_lkpMembershipPromotionAdjustmentType] FOREIGN KEY([MembershipPromotionAdjustmentTypeID])
REFERENCES [dbo].[lkpMembershipPromotionAdjustmentType] ([MembershipPromotionAdjustmentTypeID])
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] CHECK CONSTRAINT [FK_cfgMembershipPromotion_lkpMembershipPromotionAdjustmentType]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipPromotion_lkpMembershipPromotionGroup] FOREIGN KEY([MembershipPromotionGroupID])
REFERENCES [dbo].[lkpMembershipPromotionGroup] ([MembershipPromotionGroupID])
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] CHECK CONSTRAINT [FK_cfgMembershipPromotion_lkpMembershipPromotionGroup]
GO
ALTER TABLE [dbo].[cfgMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgMembershipPromotion_lkpRevenueGroup] FOREIGN KEY([RevenueGroupID])
REFERENCES [dbo].[lkpRevenueGroup] ([RevenueGroupID])
GO
ALTER TABLE [dbo].[cfgMembershipPromotion] CHECK CONSTRAINT [FK_cfgMembershipPromotion_lkpRevenueGroup]
GO
