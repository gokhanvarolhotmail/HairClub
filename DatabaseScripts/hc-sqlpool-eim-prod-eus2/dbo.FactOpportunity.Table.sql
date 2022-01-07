/****** Object:  Table [dbo].[FactOpportunity]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactOpportunity]
(
	[OpportunityId] [nvarchar](2048) NULL,
	[FactDate] [datetime] NULL,
	[FactDateKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](2048) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](2048) NULL,
	[OpportunityName] [nvarchar](2048) NULL,
	[OpportunityDescription] [nvarchar](2048) NULL,
	[StatusKey] [int] NULL,
	[OpportunityStatus] [nvarchar](2048) NULL,
	[CampaignKey] [int] NULL,
	[OpportunityCampaign] [nvarchar](2048) NULL,
	[CloseDate] [datetime] NULL,
	[CloseDateKey] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedUserKey] [int] NULL,
	[CreatedById] [nvarchar](2048) NULL,
	[LastModifiedDate] [datetime] NULL,
	[UpdateUserKey] [int] NULL,
	[LastModifiedById] [nvarchar](2048) NULL,
	[LossReasonKey] [int] NULL,
	[OpportunityLossReason] [nvarchar](2048) NULL,
	[IsDeleted] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsWon] [bit] NULL,
	[OpportunityReferralCode] [nvarchar](2048) NULL,
	[OpportunitySourceCode] [nvarchar](2048) NULL,
	[BeBackFlag] [bit] NULL,
	[OpportunityCenterType] [varchar](1024) NULL,
	[CenterNumber] [int] NULL,
	[IsOld] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
