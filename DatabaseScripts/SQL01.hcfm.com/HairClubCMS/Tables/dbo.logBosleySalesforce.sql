/* CreateDate: 04/20/2020 15:23:04.000 , ModifyDate: 04/20/2020 15:23:04.437 */
GO
CREATE TABLE [dbo].[logBosleySalesforce](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BosleyRequestID] [int] NOT NULL,
	[HCSalesforceLeadID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID__c] [int] NULL,
	[Action__c] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityType__c] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WhoId] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentDate__c] [datetime] NULL,
	[CompletionDate__c] [datetime] NULL,
	[ActivityDate] [datetime] NULL,
	[StartTime__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EndTime__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleTypeCode__c] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleTypeDescription__c] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted__c] [decimal](14, 4) NULL,
	[Performer__c] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [nvarchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FullName__c] [nvarchar](256) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[Subject] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodScale__c] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigScale__c] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation__c] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus__c] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISC__c] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[TaskID] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessed] [bit] NOT NULL,
	[IsIgnore] [bit] NOT NULL,
 CONSTRAINT [PK_logBosleySalesforce] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[logBosleySalesforce] ADD  CONSTRAINT [DF_logBosleySalesforce_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
