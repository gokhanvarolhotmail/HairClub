/* CreateDate: 02/18/2013 06:49:02.443 , ModifyDate: 12/07/2021 16:20:15.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgCenterMembershipPromotion](
	[CenterMembershipPromotionId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterId] [int] NOT NULL,
	[MembershipPromotionId] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgCenterMembershipPromotion] PRIMARY KEY CLUSTERED
(
	[CenterMembershipPromotionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipPromotion_cfgCenter] FOREIGN KEY([CenterId])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipPromotion] CHECK CONSTRAINT [FK_cfgCenterMembershipPromotion_cfgCenter]
GO
ALTER TABLE [dbo].[cfgCenterMembershipPromotion]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipPromotion_cfgMembershipPromotion] FOREIGN KEY([MembershipPromotionId])
REFERENCES [dbo].[cfgMembershipPromotion] ([MembershipPromotionID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipPromotion] CHECK CONSTRAINT [FK_cfgCenterMembershipPromotion_cfgMembershipPromotion]
GO
