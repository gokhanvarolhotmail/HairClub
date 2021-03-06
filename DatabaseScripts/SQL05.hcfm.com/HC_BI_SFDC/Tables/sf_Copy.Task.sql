/* CreateDate: 03/21/2022 07:50:17.100 , ModifyDate: 03/21/2022 13:43:31.120 */
GO
CREATE TABLE [sf_Copy].[Task](
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
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_ID_included] ON [sf_Copy].[Task]
(
	[Id] ASC
)
INCLUDE([Performer__c],[Accommodation__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Task_Action__c] ON [sf_Copy].[Task]
(
	[Action__c] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Task_Action__c_Result__c] ON [sf_Copy].[Task]
(
	[Action__c] ASC,
	[Result__c] ASC
)
INCLUDE([Id],[WhoId],[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Task_ActivityDate] ON [sf_Copy].[Task]
(
	[ActivityDate] ASC
)
INCLUDE([WhoId],[Action__c],[Result__c],[CenterNumber__c],[CenterID__c],[SaleTypeCode__c],[SourceCode__c],[IsDeleted]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Task_ActivityDate_INCL] ON [sf_Copy].[Task]
(
	[ActivityDate] ASC
)
INCLUDE([Id],[WhoId],[ActivityID__c],[CenterNumber__c],[Action__c],[Result__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Task_ActivityID__c] ON [sf_Copy].[Task]
(
	[ActivityID__c] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Task_Dates] ON [sf_Copy].[Task]
(
	[ActivityDate] ASC,
	[CompletionDate__c] ASC,
	[ReportCreateDate__c] ASC,
	[LastModifiedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Task_IsDeleted_INCL] ON [sf_Copy].[Task]
(
	[IsDeleted] ASC
)
INCLUDE([Id],[WhoId],[ActivityID__c],[CenterNumber__c],[CenterID__c],[Action__c],[Result__c],[ActivityDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Task_OncCreatedDate__c] ON [sf_Copy].[Task]
(
	[OncCreatedDate__c] ASC
)
INCLUDE([Id],[ActivityID__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Task_ReceiveBrochure__c] ON [sf_Copy].[Task]
(
	[ReceiveBrochure__c] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Task_Result__c] ON [sf_Copy].[Task]
(
	[Result__c] ASC
)
INCLUDE([Id],[WhoId]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Task_WhoId_INCL] ON [sf_Copy].[Task]
(
	[WhoId] ASC,
	[Result__c] ASC
)
INCLUDE([Id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
