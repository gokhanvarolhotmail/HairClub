/* CreateDate: 04/13/2009 16:47:20.973 , ModifyDate: 10/23/2017 12:35:40.220 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_text_msg_temp](
	[temp_id] [int] IDENTITY(1,1) NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nchar](11) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[action] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_text_msg_temp] PRIMARY KEY CLUSTERED
(
	[temp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_text_msg_temp_i1] ON [dbo].[cstd_text_msg_temp]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
