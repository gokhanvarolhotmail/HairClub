/* CreateDate: 05/05/2020 17:42:54.547 , ModifyDate: 05/05/2020 17:43:16.067 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
