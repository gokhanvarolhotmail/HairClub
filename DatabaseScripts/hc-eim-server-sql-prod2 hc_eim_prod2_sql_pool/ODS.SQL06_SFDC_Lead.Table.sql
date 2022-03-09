/****** Object:  Table [ODS].[SQL06_SFDC_Lead]    Script Date: 3/9/2022 8:40:52 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SQL06_SFDC_Lead]
(
	[Id] [nvarchar](18) NOT NULL,
	[ContactID__c] [nchar](10) NULL,
	[CenterNumber__c] [nvarchar](50) NULL,
	[CenterID__c] [nvarchar](50) NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](80) NULL,
	[Age__c] [int] NULL,
	[AgeRange__c] [nvarchar](50) NULL,
	[Birthday__c] [datetime] NULL,
	[Gender__c] [nvarchar](50) NULL,
	[Language__c] [nvarchar](50) NULL,
	[Ethnicity__c] [nvarchar](50) NULL,
	[MaritalStatus__c] [nvarchar](50) NULL,
	[Occupation__c] [nvarchar](250) NULL,
	[DISC__c] [nvarchar](50) NULL,
	[NorwoodScale__c] [nvarchar](50) NULL,
	[LudwigScale__c] [nvarchar](50) NULL,
	[SolutionOffered__c] [nvarchar](250) NULL,
	[HairLossExperience__c] [nvarchar](100) NULL,
	[HairLossFamily__c] [nvarchar](100) NULL,
	[HairLossProductOther__c] [nvarchar](150) NULL,
	[HairLossProductUsed__c] [nvarchar](100) NULL,
	[HairLossSpot__c] [nvarchar](100) NULL,
	[OriginalCampaignID__c] [nvarchar](18) NULL,
	[RecentCampaignID__c] [nvarchar](18) NULL,
	[Source_Code_Legacy__c] [nvarchar](50) NULL,
	[Promo_Code_Legacy__c] [nvarchar](50) NULL,
	[DoNotContact__c] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[SiebelID__c] [nvarchar](50) NULL,
	[GCLID__c] [nvarchar](4000) NULL,
	[OnCAffiliateID__c] [nvarchar](150) NULL,
	[IsConverted] [bit] NULL,
	[ContactStatus__c] [nvarchar](50) NULL,
	[Status] [nvarchar](50) NULL,
	[IsDeleted] [bit] NOT NULL,
	[OnCtCreatedDate__c] [datetime] NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[CreatedById] [nvarchar](255) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](255) NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[ReferralCode__c] [nvarchar](50) NULL,
	[ReferralCodeExpireDate__c] [datetime] NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[RecentSourceCode__c] [nvarchar](50) NULL,
	[ZipCode__c] [nvarchar](50) NULL,
	[Street] [nvarchar](255) NULL,
	[City] [nvarchar](50) NULL,
	[State] [nvarchar](80) NULL,
	[StateCode] [nvarchar](50) NULL,
	[Country] [nvarchar](80) NULL,
	[CountryCode] [nvarchar](50) NULL,
	[PostalCode] [nvarchar](20) NULL,
	[HTTPReferrer__c] [nvarchar](1024) NULL,
	[ConvertedAccountId] [nvarchar](18) NULL,
	[ConvertedContactId] [nvarchar](18) NULL,
	[ConvertedOpportunityId] [nvarchar](18) NULL,
	[Lead_Activity_Status__c] [nvarchar](50) NULL,
	[LeadSource] [nvarchar](80) NULL,
	[Email] [nvarchar](105) NULL,
	[Phone] [nvarchar](80) NULL,
	[MobilePhone] [nvarchar](80) NULL,
	[BosleySFID__c] [nvarchar](50) NULL,
	[externalID] [varchar](50) NULL,
	[isValid] [bit] NULL,
	[CreatedDateEst] [datetime] NULL,
	[IsNew] [bit] NULL,
	[ContactID] [varchar](50) NULL,
	[IsDuplicateByEmail] [bit] NULL,
	[IsDuplicateByName] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
