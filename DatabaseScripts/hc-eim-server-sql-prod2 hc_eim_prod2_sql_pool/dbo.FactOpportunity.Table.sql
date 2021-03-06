/****** Object:  Table [dbo].[FactOpportunity]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactOpportunity]
(
	[FactDate] [datetime] NULL,
	[FactDatekey] [int] NULL,
	[OpportunityId] [varchar](50) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [varchar](50) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [varchar](50) NULL,
	[OpportunityName] [varchar](100) NULL,
	[OpportunityDescription] [varchar](8000) NULL,
	[StatusKey] [int] NULL,
	[OpportunityStatus] [varchar](150) NULL,
	[CampaignKey] [int] NULL,
	[OpportunityCampaign] [varchar](250) NULL,
	[CloseDate] [datetime] NULL,
	[CloseDateKey] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedUserKey] [int] NULL,
	[CreatedById] [varchar](50) NULL,
	[LastModifiedDate] [datetime] NULL,
	[UpdateUserKey] [int] NULL,
	[LastModifiedById] [varchar](50) NULL,
	[LossReasonKey] [int] NULL,
	[OpportunityLossReason] [varchar](150) NULL,
	[IsDeleted] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsWon] [bit] NULL,
	[OpportunityReferralCode] [varchar](50) NULL,
	[OpportunitySourceCode] [varchar](50) NULL,
	[OpportunitySolutionOffered] [varchar](150) NULL,
	[ExternalTaskId] [varchar](200) NULL,
	[BeBackFlag] [bit] NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [int] NULL,
	[IsOld] [int] NULL,
	[Ammount] [numeric](38, 18) NULL
)
WITH
(
	DISTRIBUTION = HASH ( [OpportunityId] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
