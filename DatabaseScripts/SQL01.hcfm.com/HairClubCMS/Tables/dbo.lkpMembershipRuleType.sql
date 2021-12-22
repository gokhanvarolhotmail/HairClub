CREATE TABLE [dbo].[lkpMembershipRuleType](
	[MembershipRuleTypeID] [int] NOT NULL,
	[MembershipRuleTypeSortOrder] [int] NOT NULL,
	[MembershipRuleTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipRuleTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpMembershipBusinessRuleType] PRIMARY KEY CLUSTERED
(
	[MembershipRuleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpMembershipRuleType] ADD  CONSTRAINT [DF_lkpMembershipRuleType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
