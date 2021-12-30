/* CreateDate: 01/03/2018 16:31:36.520 , ModifyDate: 01/03/2018 17:01:10.280 */
GO
CREATE TABLE [dbo].[cstd_text_msg_log](
	[log_id] [int] NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reference] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[customer_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[message_log_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[message_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[result_status] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appt_date_time] [datetime] NULL,
	[return_text] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_1] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[language_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_date] [datetime] NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cstd_text_msg_log] ON [dbo].[cstd_text_msg_log]
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_text_msg_log_i1] ON [dbo].[cstd_text_msg_log]
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_text_msg_log_i2] ON [dbo].[cstd_text_msg_log]
(
	[appointment_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_text_msg_log_i3] ON [dbo].[cstd_text_msg_log]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
