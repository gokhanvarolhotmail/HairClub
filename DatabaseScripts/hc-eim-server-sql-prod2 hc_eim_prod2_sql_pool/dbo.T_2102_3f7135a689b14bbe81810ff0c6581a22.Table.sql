/****** Object:  Table [dbo].[T_2102_3f7135a689b14bbe81810ff0c6581a22]    Script Date: 3/1/2022 8:53:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2102_3f7135a689b14bbe81810ff0c6581a22]
(
	[FactDate] [datetime2](7) NULL,
	[FactDatekey] [int] NULL,
	[OpportunityId] [nvarchar](max) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](max) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](max) NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [int] NULL,
	[OpportunityName] [nvarchar](max) NULL,
	[OpportunityDescription] [nvarchar](max) NULL,
	[CampaignKey] [int] NULL,
	[OpportunityCampaign] [nvarchar](max) NULL,
	[CloseDate] [datetime2](7) NULL,
	[CloseDateKey] [int] NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedUserKey] [int] NULL,
	[CreatedById] [nvarchar](max) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[UpdateUserKey] [int] NULL,
	[LastModifiedById] [nvarchar](max) NULL,
	[LossReasonKey] [int] NULL,
	[OpportunityLossReason] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsWon] [bit] NULL,
	[OpportunityReferralCode] [nvarchar](max) NULL,
	[OpportunitySourceCode] [nvarchar](max) NULL,
	[OpportunitySolutionOffered] [nvarchar](max) NULL,
	[OpportunityStatus] [nvarchar](max) NULL,
	[IsOld] [int] NULL,
	[Ammount] [decimal](38, 18) NULL,
	[r37d2225ee26c4c64a3bbd8835f81ff73] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
