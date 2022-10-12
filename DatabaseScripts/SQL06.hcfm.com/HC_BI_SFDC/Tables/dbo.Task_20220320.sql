/* CreateDate: 03/21/2022 13:00:04.267 , ModifyDate: 03/21/2022 13:00:08.213 */
GO
CREATE TABLE [dbo].[Task_20220320](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[WhoId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOncContactID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Action__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityType__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDate] [datetime] NULL,
	[StartTime__c] [time](7) NULL,
	[CompletionDate__c] [datetime] NULL,
	[EndTime__c] [time](7) NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOncGender__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOncBirthday__c] [datetime] NULL,
	[Occupation__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOncEthnicity__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadOncAge__c] [int] NULL,
	[Performer__c] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted__c] [decimal](18, 2) NULL,
	[SolutionOffered__c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason__c] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISC__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleTypeCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleTypeDescription__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromoCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeZone__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OncCreatedDate__c] [datetime] NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
	[IsArchived] [bit] NOT NULL,
	[ReceiveBrochure__c] [bit] NULL,
	[ReferralCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accommodation__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_Task_20220320] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO