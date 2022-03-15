/****** Object:  Table [dbo].[DimLead]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimLead]
(
	[LeadKey] [int] IDENTITY(100000000,1) NOT NULL,
	[LeadId] [nvarchar](50) NOT NULL,
	[LeadFirstName] [nvarchar](100) NULL,
	[LeadLastname] [nvarchar](100) NULL,
	[LeadFullName] [nvarchar](250) NULL,
	[LeadBirthday] [date] NULL,
	[LeadAddress] [nvarchar](2000) NULL,
	[IsActive] [bit] NULL,
	[IsConsultFormComplete] [bit] NULL,
	[Isvalid] [bit] NULL,
	[LeadEmail] [nvarchar](255) NULL,
	[LeadPhone] [nvarchar](50) NULL,
	[LeadMobilePhone] [nvarchar](50) NULL,
	[NorwoodScale] [nvarchar](200) NULL,
	[LudwigScale] [nvarchar](200) NULL,
	[HairLossInFamily] [nvarchar](100) NULL,
	[HairLossProductUsed] [nvarchar](50) NULL,
	[HairLossSpot] [nvarchar](200) NULL,
	[GeographyKey] [int] NULL,
	[LeadPostalCode] [nvarchar](50) NULL,
	[EthnicityKey] [int] NULL,
	[LeadEthnicity] [nvarchar](100) NULL,
	[GenderKey] [int] NULL,
	[LeadGender] [nvarchar](100) NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [varchar](100) NULL,
	[LanguageKey] [int] NULL,
	[LeadLanguage] [nvarchar](100) NULL,
	[StatusKey] [int] NULL,
	[LeadStatus] [nvarchar](100) NULL,
	[LeadCreatedDate] [datetime] NOT NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedTimeKey] [int] NULL,
	[LeadLastActivityDate] [datetime] NULL,
	[LastActivityDateKey] [int] NULL,
	[LastActivityTimekey] [int] NULL,
	[DISCStyle] [nvarchar](100) NULL,
	[LeadMaritalStatus] [nvarchar](100) NULL,
	[LeadConsultReady] [int] NULL,
	[ConsultationFormReady] [int] NULL,
	[IsDeleted] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[CreateUser] [varchar](100) NULL,
	[UpdateUser] [varchar](100) NULL,
	[City] [varchar](100) NULL,
	[State] [varchar](100) NULL,
	[MaritalStatusKey] [int] NULL,
	[LeadSource] [varchar](100) NULL,
	[SourceKey] [int] NULL,
	[OriginalCommMethodkey] [int] NULL,
	[RecentCommMethodKey] [int] NULL,
	[CommunicationMethod] [varchar](250) NULL,
	[IsValidLeadName] [bit] NULL,
	[IsValidLeadLastName] [bit] NULL,
	[IsValidLeadFullName] [bit] NULL,
	[IsValidLeadPhone] [bit] NULL,
	[IsValidLeadMobilePhone] [bit] NULL,
	[IsValidLeadEmail] [bit] NULL,
	[ReviewNeeded] [bit] NULL,
	[ConvertedContactId] [nvarchar](200) NULL,
	[ConvertedAccountId] [nvarchar](200) NULL,
	[ConvertedOpportunityId] [varchar](1024) NULL,
	[ConvertedDate] [datetime2](7) NULL,
	[LastModifiedDate] [datetime] NULL,
	[SourceSystem] [varchar](100) NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[LeadExternalID] [varchar](50) NULL,
	[ServiceTerritoryID] [varchar](50) NULL,
	[OriginalCampaignId] [varchar](50) NULL,
	[OriginalCampaignKey] [int] NULL,
	[AccountID] [varchar](50) NULL,
	[LeadOccupation] [varchar](150) NULL,
	[OriginalCampaignSource] [varchar](200) NULL,
	[GCLID] [varchar](250) NULL,
	[RealCreatedDate] [datetime] NULL,
	[IsDuplicateByEmail] [bit] NULL,
	[IsDuplicateByName] [bit] NULL,
	[ReferralCode] [nvarchar](1024) NULL,
	[ReferralCodeExpirationDate] [datetime] NULL,
	[PromotionCodeKey] [int] NULL,
	[PromotionCode] [varchar](200) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[LeadId] ASC
	)
)
GO
ALTER TABLE [dbo].[DimLead] ADD  DEFAULT ((0)) FOR [IsDuplicateByEmail]
GO
ALTER TABLE [dbo].[DimLead] ADD  DEFAULT ((0)) FOR [IsDuplicateByName]
GO
