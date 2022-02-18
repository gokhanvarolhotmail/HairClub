/* CreateDate: 10/30/2017 13:40:10.167 , ModifyDate: 10/30/2017 13:40:10.167 */
GO
CREATE TABLE [dbo].[HCM_SFDC_SuccessLog_LeadPhone](
	[cst_sfdc_phone_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[upsert_status] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processed_date] [datetime] NULL,
 CONSTRAINT [HCM_SFDC_SuccessLog_LeadPhone_cst_sfdc_phone_id] PRIMARY KEY CLUSTERED
(
	[cst_sfdc_phone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
