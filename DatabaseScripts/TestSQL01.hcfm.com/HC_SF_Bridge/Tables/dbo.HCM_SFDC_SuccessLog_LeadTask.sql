/* CreateDate: 10/27/2017 17:36:40.600 , ModifyDate: 11/13/2017 15:34:42.033 */
GO
CREATE TABLE [dbo].[HCM_SFDC_SuccessLog_LeadTask](
	[cst_sfdc_task_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[upsert_status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processed_date] [datetime] NULL,
	[SFDC_CreatedDate] [datetime] NULL,
	[SFDC_LastModifiedDate] [datetime] NULL,
 CONSTRAINT [HCM_SFDC_SuccessLogLeadTask_cst_sfdc_lead_id] PRIMARY KEY CLUSTERED
(
	[cst_sfdc_task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
