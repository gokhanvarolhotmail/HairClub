/* CreateDate: 10/27/2017 10:40:38.057 , ModifyDate: 11/13/2017 12:52:48.820 */
GO
CREATE TABLE [dbo].[HCM_SFDC_SuccessLog_Lead](
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[upsert_status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processed_date] [datetime] NULL,
	[SFDC_CreatedDate] [datetime] NULL,
	[SFDC_LastModifiedDate] [datetime] NULL,
 CONSTRAINT [HCM_SFDC_SuccessLog_cst_sfdc_lead_id] PRIMARY KEY CLUSTERED
(
	[cst_sfdc_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
