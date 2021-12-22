/* CreateDate: 06/16/2021 18:23:01.270 , ModifyDate: 06/18/2021 16:45:06.203 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Synapse_pool].[FactOpportunity](
	[FactDate] [datetime] NULL,
	[FactDatekey] [int] NULL,
	[OpportunityId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadKey] [int] NULL,
	[LeadId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountKey] [int] NULL,
	[AccountId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityName] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityDescription] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusKey] [int] NULL,
	[OpportunityStatus] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignKey] [int] NULL,
	[OpportunityCampaign] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CloseDate] [datetime] NULL,
	[CloseDateKey] [int] NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedUserKey] [int] NULL,
	[CreatedById] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NULL,
	[UpdateUserKey] [int] NULL,
	[LastModifiedById] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LossReasonKey] [int] NULL,
	[OpportunityLossReason] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsWon] [bit] NULL,
	[OpportunityReferralCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunitySourceCode] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunitySolutionOffered] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalTaskId] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeBackFlag] [bit] NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [int] NULL,
	[IsOld] [int] NULL,
	[CreatedDateEst] [datetime] NULL
) ON [PRIMARY]
GO
