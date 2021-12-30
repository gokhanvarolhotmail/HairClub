/* CreateDate: 04/18/2018 11:56:01.997 , ModifyDate: 07/06/2021 17:31:37.047 */
GO
CREATE TABLE [dbo].[Lead](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContactID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age__c] [int] NULL,
	[AgeRange__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday__c] [datetime] NULL,
	[Gender__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnicity__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation__c] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISC__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SolutionOffered__c] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossExperience__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossFamily__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductOther__c] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossProductUsed__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossSpot__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalCampaignID__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecentCampaignID__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Source_Code_Legacy__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Promo_Code_Legacy__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotContact__c] [bit] NULL,
	[DoNotCall] [bit] NULL,
	[DoNotEmail__c] [bit] NULL,
	[DoNotMail__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[SiebelID__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GCLID__c] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnCAffiliateID__c] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsConverted] [bit] NULL,
	[ContactStatus__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[OnCtCreatedDate__c] [datetime] NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[ReferralCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferralCodeExpireDate__c] [datetime] NULL,
	[HardCopyPreferred__c] [bit] NULL,
	[RecentSourceCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ZipCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HTTPReferrer__c] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedAccountId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedContactId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConvertedOpportunityId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead_Activity_Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSource] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](105) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySFID__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDuplicateByEmail] [bit] NULL,
	[IsDuplicateByName] [bit] NULL,
 CONSTRAINT [PK_Lead] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_LeadIsDeletedStatusCreateINCL] ON [dbo].[Lead]
(
	[IsDeleted] ASC,
	[Status] ASC,
	[ReportCreateDate__c] ASC
)
INCLUDE([Id],[CenterNumber__c],[CenterID__c],[FirstName],[LastName]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_ContactSourceLegacy] ON [dbo].[Lead]
(
	[Source_Code_Legacy__c] ASC,
	[RecentSourceCode__c] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_ConvertedContactId_INCL] ON [dbo].[Lead]
(
	[ConvertedContactId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_Lead_Activity_Status_INCL] ON [dbo].[Lead]
(
	[Lead_Activity_Status__c] ASC
)
INCLUDE([Id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Lead_OnCtCreatedDate__c] ON [dbo].[Lead]
(
	[OnCtCreatedDate__c] ASC
)
INCLUDE([Id],[ContactID__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_OriginalCampaignID__c_INCL] ON [dbo].[Lead]
(
	[IsDeleted] ASC,
	[OriginalCampaignID__c] ASC,
	[Status] ASC,
	[Lead_Activity_Status__c] ASC
)
INCLUDE([CenterNumber__c],[CenterID__c],[ReportCreateDate__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_RecentCampaignID__c_INCL] ON [dbo].[Lead]
(
	[IsDeleted] ASC,
	[RecentCampaignID__c] ASC,
	[Status] ASC,
	[Lead_Activity_Status__c] ASC
)
INCLUDE([CenterNumber__c],[CenterID__c],[ReportCreateDate__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Lead_ReportCreateDate] ON [dbo].[Lead]
(
	[ReportCreateDate__c] ASC
)
INCLUDE([Status],[Lead_Activity_Status__c],[Id],[CenterNumber__c],[CenterID__c],[Gender__c],[RecentCampaignID__c],[Source_Code_Legacy__c],[GCLID__c],[OnCAffiliateID__c],[IsDeleted]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Lead_Status_INCL] ON [dbo].[Lead]
(
	[Status] ASC
)
INCLUDE([Id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Lead] ADD  CONSTRAINT [DF_Lead_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Lead] ADD  DEFAULT ((0)) FOR [IsDuplicateByEmail]
GO
ALTER TABLE [dbo].[Lead] ADD  DEFAULT ((0)) FOR [IsDuplicateByName]
GO
