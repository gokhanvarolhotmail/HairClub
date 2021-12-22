CREATE TABLE [dbo].[sf_staging_oncd_contact_email](
	[cst_sfdc_email_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_sfdc_lead_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [int] NULL,
	[sort_order] [int] NULL,
	[created_by_user_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sfdc_creation_date] [datetime] NULL,
	[updated_by_user_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sfdc_updated_date] [datetime] NULL,
 CONSTRAINT [PK_sf_staging_oncd_contact_email] PRIMARY KEY CLUSTERED
(
	[cst_sfdc_email_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
