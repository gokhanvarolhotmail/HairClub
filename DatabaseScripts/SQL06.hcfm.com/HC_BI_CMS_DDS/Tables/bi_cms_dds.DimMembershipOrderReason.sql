/* CreateDate: 10/03/2019 23:03:41.363 , ModifyDate: 10/03/2019 23:03:46.197 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bi_cms_dds].[DimMembershipOrderReason](
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
 CONSTRAINT [PK_DimMembershipOrderReason] PRIMARY KEY CLUSTERED
(
	[MembershipOrderReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
