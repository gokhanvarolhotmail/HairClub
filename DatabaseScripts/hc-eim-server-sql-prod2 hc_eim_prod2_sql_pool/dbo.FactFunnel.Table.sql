/****** Object:  Table [dbo].[FactFunnel]    Script Date: 2/18/2022 8:28:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactFunnel]
(
	[FactDatekey] [int] NULL,
	[FactDate] [datetime] NULL,
	[LeadCreatedDate] [datetime] NULL,
	[Leadkey] [int] NULL,
	[LeadId] [varchar](100) NULL,
	[Accountkey] [int] NULL,
	[AccountId] [varchar](100) NULL,
	[ContactId] [varchar](100) NULL,
	[CustomerId] [varchar](100) NULL,
	[Membershipkey] [int] NULL,
	[MembershipId] [varchar](100) NULL,
	[FunnelStepKey] [int] NULL,
	[FunnelStep] [varchar](100) NULL,
	[CenterKey] [varchar](100) NULL,
	[CenterID] [varchar](50) NULL,
	[CenterNumber] [int] NULL,
	[IsvalidLead] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
