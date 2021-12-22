CREATE TABLE [dbo].[lkpHansWiemannMembershipCommissions](
	[HWMembershipCommissionID] [int] IDENTITY(1,1) NOT NULL,
	[MembershipKey] [int] NULL,
	[MembershipSSID] [int] NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegment] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RevenueType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortOrder] [int] NULL,
	[Duration] [int] NULL,
	[ContractPrice] [decimal](18, 4) NULL,
	[IsTaxable] [bit] NULL,
	[IncludedHairSystems] [int] NULL,
	[IncludedVisits] [int] NULL,
	[ServiceDeduction] [decimal](18, 4) NULL,
	[HairSystemDeduction] [decimal](18, 4) NULL,
	[Tier1Min] [decimal](18, 4) NULL,
	[Tier1Max] [decimal](18, 4) NULL,
	[Tier1Pct] [decimal](7, 4) NULL,
	[Tier2Min] [decimal](18, 4) NULL,
	[Tier2Max] [decimal](18, 4) NULL,
	[Tier2Pct] [decimal](7, 4) NULL,
 CONSTRAINT [PK_lkpHansWiemannMembershipCommissions] PRIMARY KEY CLUSTERED
(
	[HWMembershipCommissionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_lkpHansWiemannMembershipCommissions_MembershipKey] ON [dbo].[lkpHansWiemannMembershipCommissions]
(
	[MembershipKey] ASC
)
INCLUDE([ServiceDeduction],[HairSystemDeduction],[Tier1Min],[Tier1Max],[Tier1Pct],[Tier2Min],[Tier2Max],[Tier2Pct]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_lkpHansWiemannMembershipCommissions_MembershipSSID] ON [dbo].[lkpHansWiemannMembershipCommissions]
(
	[MembershipSSID] ASC
)
INCLUDE([ServiceDeduction],[HairSystemDeduction],[Tier1Min],[Tier1Max],[Tier1Pct],[Tier2Min],[Tier2Max],[Tier2Pct]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
