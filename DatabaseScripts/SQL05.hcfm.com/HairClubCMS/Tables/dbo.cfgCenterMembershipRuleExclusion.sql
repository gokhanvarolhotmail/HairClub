/* CreateDate: 05/05/2020 17:42:41.010 , ModifyDate: 05/05/2020 17:42:59.877 */
GO
CREATE TABLE [dbo].[cfgCenterMembershipRuleExclusion](
	[CenterMembershipRuleExclusionID] [int] NOT NULL,
	[CenterMembershipID] [int] NOT NULL,
	[MembershipRuleTypeID] [int] NOT NULL,
	[NewMembershipID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgCenterMembershipRuleExclusion] PRIMARY KEY CLUSTERED
(
	[CenterMembershipRuleExclusionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
