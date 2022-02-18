/* CreateDate: 02/14/2022 14:59:14.413 , ModifyDate: 02/14/2022 14:59:14.413 */
GO
CREATE TABLE [dbo].[SFDC_HCM_LeadPhone](
	[cst_sfdc_phone_id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[create_date] [datetime] NULL,
	[updated_date] [datetime] NULL
) ON [PRIMARY]
GO
