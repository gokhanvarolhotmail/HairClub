/* CreateDate: 01/30/2020 07:48:32.590 , ModifyDate: 03/08/2020 19:14:07.893 */
GO
CREATE TABLE [dbo].[datClientMilestoneLog](
	[ClientMilestoneLogID] [int] IDENTITY(1,1) NOT NULL,
	[ClientMilestoneProcessID] [int] NOT NULL,
	[SessionGUID] [uniqueidentifier] NOT NULL,
	[BatchID] [int] NOT NULL,
	[ActivityID__c] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Customer__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID__c] [int] NULL,
	[CenterNumber__c] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[DoNotContactFlag] [bit] NULL,
	[CanContactForPromotionsByEmail] [bit] NULL,
	[Action__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityType__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[AppointmentDate__c] [date] NULL,
	[ActivityDate] [date] NULL,
	[StartTime__c] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletionDate__c] [datetime] NULL,
	[EndTime__c] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadFirstName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Performer__c] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[OncCreatedDate__c] [datetime] NULL,
	[OncUpdatedDate__c] [datetime] NULL,
	[ClientMilestoneStatusID] [int] NOT NULL,
	[OriginalClientMilestoneLogID] [int] NULL,
	[IsReprocessFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datClientMilestoneLog] PRIMARY KEY CLUSTERED
(
	[ClientMilestoneLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMilestoneLog_ClientMilestoneProcessID_INCL] ON [dbo].[datClientMilestoneLog]
(
	[ClientMilestoneProcessID] ASC
)
INCLUDE([ClientIdentifier],[SalesOrderDetailKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMilestoneLog_ClientMilestoneStatusID] ON [dbo].[datClientMilestoneLog]
(
	[ClientMilestoneStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
