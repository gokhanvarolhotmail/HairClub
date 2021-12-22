/* CreateDate: 10/04/2019 14:09:30.217 , ModifyDate: 10/14/2020 13:51:02.933 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Campaign](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[ParentId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Channel__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortcodeChannel__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortcodeMedia__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Source__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortcodeOrigin__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShortcodeFormat__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Goal__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCodeName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCodeNumber__c] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Gender__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CampaignType__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CommunicationType__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreeName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TollFreeMobileName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[URLDomain__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenerateCodes__c] [bit] NULL,
	[SourceCode_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DPNCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWFCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWCCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNIS__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DNISMobile__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Referrer__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SCNumber__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MPNCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MWFCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MWCCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ACE_Decription__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WebCode__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCodeDisplay__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberSent] [int] NULL,
	[ExpectedResponse] [float] NULL,
	[BudgetedCost] [money] NULL,
	[ActualCost] [money] NULL,
	[ExpectedRevenue] [money] NULL,
	[NumberOfResponses] [int] NULL,
	[NumberOfLeads] [int] NULL,
	[NumberOfConvertedLeads] [int] NULL,
	[NumberOfContacts] [int] NULL,
	[NumberOfOpportunities] [int] NULL,
	[NumberOfWonOpportunities] [int] NULL,
	[AmountAllOpportunities] [money] NULL,
	[AmountWonOpportunities] [money] NULL,
	[Promo_Code_L__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName_L__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsInHouseSourceFlag_L__c] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Number_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberTypeID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberType_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediaID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Media_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MediaCode_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Notes_L__c] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Campaign_Counter__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level02LocationCode_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level02Location_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level03ID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level03LanguageCode_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level03Language_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level04ID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level04FormatCode_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level04Format_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level05ID_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level05CreativeCode_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level05Creative_L__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Campaign] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Campaign_IsDeleted_INCL] ON [dbo].[Campaign]
(
	[IsDeleted] ASC,
	[MWCCode__c] ASC,
	[MWFCode__c] ASC,
	[MPNCode__c] ASC,
	[DPNCode__c] ASC,
	[DWFCode__c] ASC,
	[DWCCode__c] ASC
)
INCLUDE([Id],[SourceCode_L__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
