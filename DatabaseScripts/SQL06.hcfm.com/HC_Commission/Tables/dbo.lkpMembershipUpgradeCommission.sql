CREATE TABLE [dbo].[lkpMembershipUpgradeCommission](
	[MembershipUpgradeKey] [int] IDENTITY(1,1) NOT NULL,
	[FromMembershipKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[Commission] [money] NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
 CONSTRAINT [PK_lkpMembershipUpgradeCommission] PRIMARY KEY CLUSTERED
(
	[MembershipUpgradeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
