CREATE TABLE [dbo].[tmp_SFDC_HCM_LeadTask](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[cst_sfdc_task_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityTypeCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentDate] [datetime] NULL,
	[DueDate] [datetime] NULL,
	[StartTime] [time](7) NULL,
	[CompletionDate] [datetime] NULL,
	[CompletionTime] [datetime] NULL,
	[SalesforceAssignedToUserId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Birthday] [datetime] NULL,
	[Occupation] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ethnicity] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatus] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Norwood] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Ludwig] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[Performer] [nvarchar](102) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceQuoted] [decimal](18, 2) NULL,
	[SolutionOffered] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NoSaleReason] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DISC] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleTypeCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleTypeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PromotionCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Timezone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadStatus] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceCreatedByUserId] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceCreatedDate] [datetime] NULL,
	[SalesforceLastModifiedByUserId] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceLastModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_tmp_SFDC_HCM_LeadTask] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmp_SFDC_HCM_LeadTask_activity_id] ON [dbo].[tmp_SFDC_HCM_LeadTask]
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmp_SFDC_HCM_LeadTask_contact_id] ON [dbo].[tmp_SFDC_HCM_LeadTask]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmp_SFDC_HCM_LeadTask_cst_sfdc_lead_id] ON [dbo].[tmp_SFDC_HCM_LeadTask]
(
	[cst_sfdc_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_tmp_SFDC_HCM_LeadTask_cst_sfdc_task_id] ON [dbo].[tmp_SFDC_HCM_LeadTask]
(
	[cst_sfdc_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmp_SFDC_HCM_LeadTask_DueDate] ON [dbo].[tmp_SFDC_HCM_LeadTask]
(
	[DueDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
