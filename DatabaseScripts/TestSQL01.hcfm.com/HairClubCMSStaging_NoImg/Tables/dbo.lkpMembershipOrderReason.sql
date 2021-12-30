/* CreateDate: 02/18/2013 06:49:02.567 , ModifyDate: 12/28/2021 09:20:54.473 */
GO
CREATE TABLE [dbo].[lkpMembershipOrderReason](
	[MembershipOrderReasonID] [int] NOT NULL,
	[MembershipOrderReasonTypeID] [int] NOT NULL,
	[MembershipOrderReasonSortOrder] [int] NOT NULL,
	[MembershipOrderReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipOrderReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegmentID] [int] NULL,
	[RevenueTypeID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpReason] PRIMARY KEY CLUSTERED
(
	[MembershipOrderReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpMembershipOrderReason]  WITH CHECK ADD  CONSTRAINT [FK_lkpMembershipOrderReason_lkpBusinessSegment] FOREIGN KEY([BusinessSegmentID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[lkpMembershipOrderReason] CHECK CONSTRAINT [FK_lkpMembershipOrderReason_lkpBusinessSegment]
GO
ALTER TABLE [dbo].[lkpMembershipOrderReason]  WITH CHECK ADD  CONSTRAINT [FK_lkpMembershipOrderReason_lkpMembershipOrderReasonType] FOREIGN KEY([MembershipOrderReasonTypeID])
REFERENCES [dbo].[lkpMembershipOrderReasonType] ([MembershipOrderReasonTypeID])
GO
ALTER TABLE [dbo].[lkpMembershipOrderReason] CHECK CONSTRAINT [FK_lkpMembershipOrderReason_lkpMembershipOrderReasonType]
GO
ALTER TABLE [dbo].[lkpMembershipOrderReason]  WITH CHECK ADD  CONSTRAINT [FK_lkpMembershipOrderReason_lkpRevenueGroup] FOREIGN KEY([RevenueTypeID])
REFERENCES [dbo].[lkpRevenueGroup] ([RevenueGroupID])
GO
ALTER TABLE [dbo].[lkpMembershipOrderReason] CHECK CONSTRAINT [FK_lkpMembershipOrderReason_lkpRevenueGroup]
GO
