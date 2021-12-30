/* CreateDate: 05/20/2010 15:52:45.813 , ModifyDate: 09/10/2019 22:54:21.270 */
GO
CREATE TABLE [dbo].[hcmtbl_leadstoimport_pagelynx_history](
	[row_id] [int] IDENTITY(1,1) NOT NULL,
	[run_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[processed_date] [datetime] NULL,
	[action_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[territory] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_date] [datetime] NULL,
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
	[appt_date] [datetime] NULL,
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
	[brochure_download] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_hcmtbl_leadstoimport_pagelynx_history] PRIMARY KEY CLUSTERED
(
	[row_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [hcmtbl_leadstoimport_pagelynx_history_i1] ON [dbo].[hcmtbl_leadstoimport_pagelynx_history]
(
	[territory] ASC,
	[last_name] ASC,
	[first_name] ASC,
	[street] ASC,
	[email] ASC,
	[phone] ASC,
	[gender] ASC,
	[cst_language] ASC
)
INCLUDE([create_date],[create_time],[zip]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hcmtbl_leadstoimport_pagelynx_history] ADD  CONSTRAINT [DF_hcmtbl_leadstoimport_pagelynx_history_brochure_download]  DEFAULT ('N') FOR [brochure_download]
GO
