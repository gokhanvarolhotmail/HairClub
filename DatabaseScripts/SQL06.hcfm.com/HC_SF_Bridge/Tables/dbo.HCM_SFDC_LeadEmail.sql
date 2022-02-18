/* CreateDate: 02/17/2022 13:35:43.490 , ModifyDate: 02/17/2022 13:35:43.490 */
GO
CREATE TABLE [dbo].[HCM_SFDC_LeadEmail](
	[cst_sfdc_email_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL
) ON [PRIMARY]
GO
