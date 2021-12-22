/* CreateDate: 03/06/2017 16:04:35.630 , ModifyDate: 01/09/2019 10:09:50.497 */
GO
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
GO
