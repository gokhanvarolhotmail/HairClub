/* CreateDate: 09/04/2007 09:40:44.227 , ModifyDate: 11/02/2015 10:00:43.517 */
GO
CREATE TABLE [dbo].[hcmtbl_leadstoimport_pagelynx](
	[territory] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_date] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_time] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_by] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[street] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[street2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appt_date] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appt_time] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[act_code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_code] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[promo] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[recordid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gender] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_age_range] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[loss_alternatives] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_language] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_sessionid] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_affiliateid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[alt_center] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_loginid] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone3] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone4] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone5] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[brochure_download] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hcmtbl_leadstoimport_pagelynx] ADD  DEFAULT ('ENGLISH') FOR [cst_language]
GO
ALTER TABLE [dbo].[hcmtbl_leadstoimport_pagelynx] ADD  CONSTRAINT [DF_hcmtbl_leadstoimport_pagelynx_brochure_download]  DEFAULT ('N') FOR [brochure_download]
GO
