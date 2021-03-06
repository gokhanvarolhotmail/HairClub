/****** Object:  Table [ODS].[vwLeadOld]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[vwLeadOld]
(
	[Id] [varchar](8000) NULL,
	[CenterNumber__c] [varchar](8000) NULL,
	[FirstName] [varchar](8000) NULL,
	[LastName] [varchar](8000) NULL,
	[Birthday__c] [varchar](8000) NULL,
	[Gender__c] [varchar](8000) NULL,
	[Language__c] [varchar](8000) NULL,
	[Ethnicity__c] [varchar](8000) NULL,
	[MaritalStatus__c] [varchar](8000) NULL,
	[Occupation__c] [varchar](8000) NULL,
	[NorwoodScale__c] [varchar](8000) NULL,
	[LudwigScale__c] [varchar](8000) NULL,
	[HairLossFamily__c] [varchar](8000) NULL,
	[HairLossProductUsed__c] [varchar](8000) NULL,
	[HairLossSpot__c] [varchar](8000) NULL,
	[OriginalCampaignID__c] [varchar](8000) NULL,
	[DoNotContact__c] [varchar](8000) NULL,
	[DoNotCall] [varchar](8000) NULL,
	[DoNotEmail__c] [varchar](8000) NULL,
	[DoNotMail__c] [varchar](8000) NULL,
	[DoNotText__c] [varchar](8000) NULL,
	[GCLID__c] [varchar](8000) NULL,
	[Status] [varchar](8000) NULL,
	[IsDeleted] [varchar](8000) NULL,
	[CreatedDate] [varchar](8000) NULL,
	[LastModifiedDate] [varchar](8000) NULL,
	[RecentSourceCode__c] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[State] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[LeadSource] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[MobilePhone] [varchar](8000) NULL,
	[isValid] [varchar](8000) NULL,
	[externalID] [varchar](8000) NULL,
	[CreatedDateEst] [varchar](8000) NULL,
	[ConvertedContactId] [varchar](8000) NULL,
	[Source_Code_Legacy__c] [varchar](8000) NULL,
	[Street] [varchar](8000) NULL,
	[IsNew] [varchar](8000) NULL,
	[ConvertedAccountId] [varchar](8000) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedById] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
