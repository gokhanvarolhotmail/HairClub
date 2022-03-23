/* CreateDate: 03/16/2022 08:59:50.703 , ModifyDate: 03/16/2022 08:59:51.060 */
GO
CREATE TABLE [dbo].[SFDC_HCM_LeadTask](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BatchID] [int] NULL,
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
	[IsProcessedFlag] [bit] NULL,
	[IsExcludedFlag] [bit] NULL,
	[ExclusionMessage] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_SFDC_HCM_LeadTask] PRIMARY KEY CLUSTERED
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SFDC_HCM_LeadTask] ADD  CONSTRAINT [DF_SFDC_HCM_LeadTask_IsProcessedFlag]  DEFAULT ((0)) FOR [IsProcessedFlag]
GO
ALTER TABLE [dbo].[SFDC_HCM_LeadTask] ADD  CONSTRAINT [DF_SFDC_HCM_LeadTask_IsExcludedFlag]  DEFAULT ((0)) FOR [IsExcludedFlag]
GO
ALTER TABLE [dbo].[SFDC_HCM_LeadTask] ADD  CONSTRAINT [DF_SFDC_HCM_LeadTask_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[SFDC_HCM_LeadTask] ADD  CONSTRAINT [DF_SFDC_HCM_LeadTask_CreateUser]  DEFAULT (N'sa') FOR [CreateUser]
GO
ALTER TABLE [dbo].[SFDC_HCM_LeadTask] ADD  CONSTRAINT [DF_SFDC_HCM_LeadTask_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[SFDC_HCM_LeadTask] ADD  CONSTRAINT [DF_SFDC_HCM_LeadTask_LastUpdateUser]  DEFAULT (N'sa') FOR [LastUpdateUser]
GO
