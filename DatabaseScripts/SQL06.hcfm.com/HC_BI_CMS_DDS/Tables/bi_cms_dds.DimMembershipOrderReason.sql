/* CreateDate: 03/17/2022 11:57:06.443 , ModifyDate: 03/17/2022 11:57:15.930 */
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
