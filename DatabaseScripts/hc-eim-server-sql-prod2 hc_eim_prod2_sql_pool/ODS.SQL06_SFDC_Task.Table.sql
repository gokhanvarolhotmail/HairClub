/****** Object:  Table [ODS].[SQL06_SFDC_Task]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SQL06_SFDC_Task]
(
	[Id] [nvarchar](18) NOT NULL,
	[WhoId] [nvarchar](18) NULL,
	[ActivityID__c] [nchar](10) NULL,
	[LeadOncContactID__c] [nchar](10) NULL,
	[CenterNumber__c] [nvarchar](50) NULL,
	[CenterID__c] [nvarchar](50) NULL,
	[Action__c] [nvarchar](50) NULL,
	[Result__c] [nvarchar](50) NULL,
	[ActivityType__c] [nvarchar](50) NULL,
	[ActivityDate] [datetime] NULL,
	[StartTime__c] [time](7) NULL,
	[CompletionDate__c] [datetime] NULL,
	[EndTime__c] [time](7) NULL,
	[OwnerId] [nvarchar](18) NULL,
	[LeadOncGender__c] [nvarchar](50) NULL,
	[LeadOncBirthday__c] [datetime] NULL,
	[Occupation__c] [nvarchar](100) NULL,
	[LeadOncEthnicity__c] [nvarchar](100) NULL,
	[MaritalStatus__c] [nvarchar](100) NULL,
	[NorwoodScale__c] [nvarchar](100) NULL,
	[LudwigScale__c] [nvarchar](100) NULL,
	[LeadOncAge__c] [int] NULL,
	[Performer__c] [nvarchar](102) NULL,
	[PriceQuoted__c] [decimal](18, 2) NULL,
	[SolutionOffered__c] [nvarchar](100) NULL,
	[NoSaleReason__c] [nvarchar](200) NULL,
	[DISC__c] [nvarchar](50) NULL,
	[SaleTypeCode__c] [nvarchar](50) NULL,
	[SaleTypeDescription__c] [nvarchar](50) NULL,
	[SourceCode__c] [nvarchar](50) NULL,
	[PromoCode__c] [nvarchar](50) NULL,
	[TimeZone__c] [nvarchar](50) NULL,
	[OncCreatedDate__c] [datetime] NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[IsDeleted] [bit] NULL,
	[CreatedById] [nvarchar](18) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) NULL,
	[LastModifiedDate] [datetime] NULL,
	[IsArchived] [bit] NULL,
	[ReceiveBrochure__c] [bit] NULL,
	[ReferralCode__c] [nvarchar](50) NULL,
	[Accommodation__c] [nvarchar](50) NULL,
	[externalID] [varchar](50) NULL,
	[CreatedDateEst] [datetime] NULL,
	[IsNew] [bit] NULL,
	[IsOld] [bit] NULL,
	[ContactKey] [int] NULL,
	[ContactId] [varchar](50) NULL,
	[OpportunityAmmount] [numeric](38, 18) NULL,
	[OppotunityAmmount] [numeric](38, 18) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
