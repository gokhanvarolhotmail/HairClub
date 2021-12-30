/* CreateDate: 10/26/2017 22:08:59.460 , ModifyDate: 11/30/2017 09:30:42.860 */
GO
CREATE TABLE [dbo].[HCM_SFDC_LeadTask](
	[cst_sfdc_task_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_sfdc_client_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[BatchID] [int] NULL,
	[CenterID] [int] NULL,
	[ActivityID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentDate] [date] NULL,
	[ActivityDate] [date] NULL,
	[StartTime] [time](7) NULL,
	[ActionCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletionDate] [date] NULL,
	[EndTime] [time](7) NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityCreateDate] [datetime] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityLastUpdate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsReprocessFlag] [bit] NULL,
	[IsProcessedFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__HCM_SFDC__cst_sfdc_task_id] PRIMARY KEY CLUSTERED
(
	[cst_sfdc_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IDX_HCM_SFDC_LeadTask_contact_activity_id] ON [dbo].[HCM_SFDC_LeadTask]
(
	[contact_activity_id] ASC
)
INCLUDE([cst_sfdc_task_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_HCM_SFDC_LeadTask_IsProcessedFlag] ON [dbo].[HCM_SFDC_LeadTask]
(
	[IsProcessedFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_HCM_SFDC_LeadTask_IsReprocessFlag] ON [dbo].[HCM_SFDC_LeadTask]
(
	[IsReprocessFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
