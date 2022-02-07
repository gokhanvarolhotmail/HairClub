/****** Object:  Table [dbo].[T_2067_32d034052c28423eb4399515190ef452]    Script Date: 2/7/2022 10:45:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2067_32d034052c28423eb4399515190ef452]
(
	[LeadId] [nvarchar](max) NULL,
	[LeadFirstName] [nvarchar](max) NULL,
	[LeadLastname] [nvarchar](max) NULL,
	[LeadFullName] [nvarchar](max) NULL,
	[LeadBirthday] [date] NULL,
	[LeadAddress] [nvarchar](max) NULL,
	[Isvalid] [bit] NULL,
	[GCLID] [nvarchar](max) NULL,
	[LeadEmail] [nvarchar](max) NULL,
	[LeadPhone] [nvarchar](max) NULL,
	[LeadMobilePhone] [nvarchar](max) NULL,
	[NorwoodScale] [nvarchar](max) NULL,
	[LudwigScale] [nvarchar](max) NULL,
	[HairLossInFamily] [nvarchar](max) NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [nvarchar](max) NULL,
	[HairLossProductUsed] [nvarchar](max) NULL,
	[HairLossSpot] [nvarchar](max) NULL,
	[GeographyKey] [int] NULL,
	[LeadPostalCode] [nvarchar](max) NULL,
	[EthnicityKey] [int] NULL,
	[LeadEthnicity] [nvarchar](max) NULL,
	[GenderKey] [int] NULL,
	[LeadGender] [nvarchar](max) NULL,
	[LanguageKey] [int] NULL,
	[LeadLanguage] [nvarchar](max) NULL,
	[StatusKey] [int] NULL,
	[LeadStatus] [nvarchar](max) NULL,
	[LeadCreatedDate] [datetime2](7) NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedTimeKey] [int] NULL,
	[LeadLastActivityDate] [datetime2](7) NULL,
	[LastActivityDateKey] [int] NULL,
	[LastActivityTimekey] [int] NULL,
	[DISCStyle] [nvarchar](max) NULL,
	[LeadMaritalStatus] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[CreateUser] [nvarchar](max) NULL,
	[UpdateUser] [nvarchar](max) NULL,
	[City] [nvarchar](max) NULL,
	[State] [nvarchar](max) NULL,
	[MaritalStatusKey] [int] NULL,
	[LeadSource] [nvarchar](max) NULL,
	[SourceKey] [int] NULL,
	[IsValidLeadName] [bit] NULL,
	[IsValidLeadLastName] [bit] NULL,
	[IsValidLeadFullName] [bit] NULL,
	[IsValidLeadPhone] [bit] NULL,
	[IsValidLeadMobilePhone] [bit] NULL,
	[IsValidLeadEmail] [bit] NULL,
	[ReviewNeeded] [bit] NULL,
	[ConvertedContactId] [nvarchar](max) NULL,
	[ConvertedAccountId] [nvarchar](max) NULL,
	[ConvertedOpportunityId] [nvarchar](max) NULL,
	[ConvertedDate] [datetime2](7) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[DWH_CreatedDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[LeadExternalID] [nvarchar](max) NULL,
	[OriginalCampaignId] [nvarchar](max) NULL,
	[OriginalCampaignKey] [int] NULL,
	[ServiceTerritoryID] [nvarchar](max) NULL,
	[ReferralCodeExpirationDate] [datetime2](7) NULL,
	[ReferralCode] [nvarchar](max) NULL,
	[OriginalCampaignSource] [nvarchar](max) NULL,
	[PromotionCode] [nvarchar](max) NULL,
	[PromotionCodeKey] [int] NULL,
	[LeadOccupation] [nvarchar](max) NULL,
	[r2a7664db447048848307155228d91a36] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
