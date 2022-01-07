/****** Object:  Table [dbo].[T_2399_75d495772ac94b7bab670f35bfeef40d]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2399_75d495772ac94b7bab670f35bfeef40d]
(
	[LeadId] [nvarchar](max) NULL,
	[LeadName] [nvarchar](max) NULL,
	[LeadLastname] [nvarchar](max) NULL,
	[LeadFullName] [nvarchar](max) NULL,
	[LeadBirthday] [date] NULL,
	[LeadAddress] [nvarchar](max) NULL,
	[IsActive] [int] NULL,
	[IsConsultFormComplete] [int] NULL,
	[Isvalid] [int] NULL,
	[IsReferral] [int] NULL,
	[LeadScore] [decimal](18, 0) NULL,
	[LeadEmail] [nvarchar](max) NULL,
	[LeadPhone] [nvarchar](max) NULL,
	[LeadMobilePhone] [nvarchar](max) NULL,
	[LeadAddress1] [nvarchar](max) NULL,
	[NorwoodScale] [nvarchar](max) NULL,
	[LudwigScale] [nvarchar](max) NULL,
	[HairLossScaleKey] [decimal](18, 0) NULL,
	[HairLossInFamily] [nvarchar](max) NULL,
	[HairLossSpot] [nvarchar](max) NULL,
	[HairLossProductUsed] [nvarchar](max) NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[SegmentKey] [decimal](18, 0) NULL,
	[GeographyKey] [int] NULL,
	[LeadPostalCode] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[State] [nvarchar](max) NULL,
	[EthnicityKey] [decimal](18, 0) NULL,
	[LeadEthnicity] [nvarchar](max) NULL,
	[GenderKey] [decimal](18, 0) NULL,
	[LeadGender] [nvarchar](max) NULL,
	[OriginalCampaignKey] [decimal](18, 0) NULL,
	[CommunicationMethod] [nvarchar](max) NULL,
	[OriginalCampaignCode] [nvarchar](max) NULL,
	[OriginalSourceCode] [nvarchar](max) NULL,
	[OriginalCommMethodkey] [int] NULL,
	[CenterKey] [decimal](18, 0) NULL,
	[CenterNumber] [nvarchar](max) NULL,
	[LanguageKey] [decimal](18, 0) NULL,
	[LeadLanguage] [nvarchar](max) NULL,
	[StatusKey] [decimal](18, 0) NULL,
	[LeadStatus] [nvarchar](max) NULL,
	[FunnelStepKey] [decimal](18, 0) NULL,
	[FunnelStep] [nvarchar](max) NULL,
	[LeadCreatedDate] [datetime2](7) NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedTimeKey] [int] NULL,
	[RecentCampaignKey] [int] NULL,
	[RecentCampaignCode] [nvarchar](max) NULL,
	[RecentSourceCode] [nvarchar](max) NULL,
	[RecentCommMethodKey] [int] NULL,
	[LeadLastActivityDate] [datetime2](7) NULL,
	[LastActivityDateKey] [int] NULL,
	[LastActivityTimekey] [int] NULL,
	[DISCStyle] [nvarchar](max) NULL,
	[LeadMaritalStatus] [nvarchar](max) NULL,
	[MaritalStatusKey] [int] NULL,
	[LeadOccupation] [nvarchar](max) NULL,
	[OccupationKey] [int] NULL,
	[LeadSource] [nvarchar](max) NULL,
	[SourceKey] [int] NULL,
	[ConsultationFormReady] [int] NULL,
	[LeadConsultReady] [int] NULL,
	[CreateUser] [nvarchar](max) NULL,
	[UpdateUser] [nvarchar](max) NULL,
	[DWHLastUpdateDate] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[IsValidLeadName] [bit] NULL,
	[IsValidLeadLastName] [bit] NULL,
	[IsValidLeadFullName] [bit] NULL,
	[IsValidLeadPhone] [bit] NULL,
	[IsValidLeadMobilePhone] [bit] NULL,
	[IsValidLeadEmail] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[ReviewNeeded] [bit] NULL,
	[ConvertedContactId] [nvarchar](max) NULL,
	[ConvertedAccountId] [nvarchar](max) NULL,
	[ConvertedOpportunityId] [nvarchar](max) NULL,
	[ConvertedDate] [datetime2](7) NULL,
	[r9a85a337795045cab37029d6199494c2] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
