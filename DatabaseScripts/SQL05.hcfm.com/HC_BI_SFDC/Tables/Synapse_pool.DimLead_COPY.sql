/* CreateDate: 03/21/2022 07:50:17.840 , ModifyDate: 03/21/2022 13:43:22.933 */
GO
CREATE TABLE [Synapse_pool].[DimLead_COPY](
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LeadFirstName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadLastname] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadFullName] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadBirthday] [date] NULL,
	[LeadAddress] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[IsConsultFormComplete] [bit] NULL,
	[Isvalid] [bit] NULL,
	[LeadEmail] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadPhone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadMobilePhone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossInFamily] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GeographyKey] [int] NULL,
	[LeadPostalCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityKey] [int] NULL,
	[LeadEthnicity] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderKey] [int] NULL,
	[LeadGender] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageKey] [int] NULL,
	[LeadLanguage] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusKey] [int] NULL,
	[LeadStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreatedDate] [datetime] NOT NULL,
	[CreatedDateKey] [int] NULL,
	[CreatedTimeKey] [int] NULL,
	[LeadLastActivityDate] [datetime] NULL,
	[LastActivityDateKey] [int] NULL,
	[LastActivityTimekey] [int] NULL,
	[DISCStyle] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadMaritalStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadConsultReady] [int] NULL,
	[ConsultationFormReady] [int] NULL,
	[IsDeleted] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotContact] [bit] NULL,
	[DoNotEmail] [bit] NULL,
	[DoNotMail] [bit] NULL,
	[DoNotText] [bit] NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusKey] [int] NULL,
	[LeadSource] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[OriginalCommMethodkey] [int] NULL,
	[RecentCommMethodKey] [int] NULL,
	[CommunicationMethod] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsValidLeadName] [bit] NULL,
	[IsValidLeadLastName] [bit] NULL,
	[IsValidLeadFullName] [bit] NULL,
	[IsValidLeadPhone] [bit] NULL,
	[IsValidLeadMobilePhone] [bit] NULL,
	[IsValidLeadEmail] [bit] NULL,
	[ReviewNeeded] [bit] NULL,
	[ConvertedContactId] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedAccountId] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedOpportunityId] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedDate] [datetime2](7) NULL,
	[LastModifiedDate] [datetime] NULL,
	[SourceSystem] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[LeadExternalID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceTerritoryID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalCampaignId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalCampaignKey] [int] NULL,
	[AccountID] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOccupation] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalCampaignSource] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GCLID] [varchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
