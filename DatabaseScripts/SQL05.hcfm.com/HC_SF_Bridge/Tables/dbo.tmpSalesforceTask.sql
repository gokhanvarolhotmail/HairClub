/* CreateDate: 06/06/2018 11:17:33.587 , ModifyDate: 06/14/2018 20:54:06.117 */
GO
CREATE TABLE [dbo].[tmpSalesforceTask](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[WhoId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterID__c] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Action__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivityType__c] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode__c] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentDate__c] [date] NULL,
	[ActivityDate] [date] NULL,
	[StartTime__c] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletionDate__c] [datetime] NULL,
	[EndTime__c] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReportCreateDate__c] [datetime] NULL,
	[OncCreatedDate__c] [datetime] NULL,
	[OncUpdatedDate__c] [datetime] NULL,
	[SalesforceID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tmpSalesforceTask] PRIMARY KEY CLUSTERED
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmpSalesforceTask_ActivityID] ON [dbo].[tmpSalesforceTask]
(
	[ActivityID__c] ASC
)
INCLUDE([SalesforceID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
