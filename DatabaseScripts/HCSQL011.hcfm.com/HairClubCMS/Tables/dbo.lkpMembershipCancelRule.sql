/* CreateDate: 02/18/2013 06:49:02.750 , ModifyDate: 11/28/2014 22:02:31.057 */
GO
CREATE TABLE [dbo].[lkpMembershipCancelRule](
	[MembershipCancelRuleID] [int] NOT NULL,
	[MembershipCancelRuleSortOrder] [int] NOT NULL,
	[MembershipCancelRuleDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CMembershipCancelRuleShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpMembershipCancelRule] PRIMARY KEY CLUSTERED
(
	[MembershipCancelRuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
