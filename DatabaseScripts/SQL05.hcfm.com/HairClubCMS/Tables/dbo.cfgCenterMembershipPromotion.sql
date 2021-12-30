/* CreateDate: 05/05/2020 17:42:40.893 , ModifyDate: 05/05/2020 17:42:59.683 */
GO
CREATE TABLE [dbo].[cfgCenterMembershipPromotion](
	[CenterMembershipPromotionId] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
