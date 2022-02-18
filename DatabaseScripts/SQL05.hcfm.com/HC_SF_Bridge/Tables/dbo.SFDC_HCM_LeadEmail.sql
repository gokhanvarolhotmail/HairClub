/* CreateDate: 02/14/2022 15:32:42.493 , ModifyDate: 02/14/2022 15:32:42.493 */
GO
CREATE TABLE [dbo].[SFDC_HCM_LeadEmail](
	[cst_sfdc_email_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL
) ON [PRIMARY]
GO
