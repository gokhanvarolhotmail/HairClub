/* CreateDate: 01/03/2018 16:31:36.463 , ModifyDate: 01/03/2018 17:01:08.560 */
GO
CREATE TABLE [dbo].[cstd_text_msg_temp](
	[temp_id] [int] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[action] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cstd_text_msg_temp] ON [dbo].[cstd_text_msg_temp]
(
	[temp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_text_msg_temp_i1] ON [dbo].[cstd_text_msg_temp]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
