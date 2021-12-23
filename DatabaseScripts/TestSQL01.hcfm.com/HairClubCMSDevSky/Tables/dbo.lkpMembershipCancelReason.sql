/* CreateDate: 08/27/2008 12:06:18.220 , ModifyDate: 12/07/2021 16:20:16.187 */
GO
CREATE TABLE [dbo].[lkpMembershipCancelReason](
	[MembershipCancelReasonID] [int] NOT NULL,
	[MembershipCancelReasonSortOrder] [int] NOT NULL,
	[RevenueGroupID] [int] NULL,
	[MembershipCancelReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipCancelReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpMembershipCancelReason] PRIMARY KEY CLUSTERED
(
	[MembershipCancelReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpMembershipCancelReason] ADD  CONSTRAINT [DF_lkpMembershipCancelReason_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpMembershipCancelReason]  WITH CHECK ADD  CONSTRAINT [FK_lkpMembershipCancelReason_lkpRevenueGroup] FOREIGN KEY([RevenueGroupID])
REFERENCES [dbo].[lkpRevenueGroup] ([RevenueGroupID])
GO
ALTER TABLE [dbo].[lkpMembershipCancelReason] CHECK CONSTRAINT [FK_lkpMembershipCancelReason_lkpRevenueGroup]
GO
