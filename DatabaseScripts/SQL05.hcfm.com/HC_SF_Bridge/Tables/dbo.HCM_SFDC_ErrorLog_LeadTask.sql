/* CreateDate: 11/06/2017 11:52:12.650 , ModifyDate: 11/06/2017 11:52:12.650 */
GO
CREATE TABLE [dbo].[HCM_SFDC_ErrorLog_LeadTask](
	[leadtask_error_date] [datetime] NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_sfdc_lead_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[subject] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[due_date] [datetime] NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[completion_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[usercode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ownerid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sf_status] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[disc_style] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price_quoted] [money] NULL,
	[ludwig] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Maritial_status] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[norwood] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Occupation_status] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[solution_offered] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[no_sale_reason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[performer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_type_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[error] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
