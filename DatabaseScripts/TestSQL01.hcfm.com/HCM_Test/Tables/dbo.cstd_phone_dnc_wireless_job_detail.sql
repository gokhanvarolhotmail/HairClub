/* CreateDate: 03/22/2016 11:02:14.653 , ModifyDate: 09/10/2019 22:57:06.243 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_phone_dnc_wireless_job_detail](
	[phone_dnc_wireless_job_detail_id] [uniqueidentifier] NOT NULL,
	[phone_dnc_wireless_job_id] [uniqueidentifier] NOT NULL,
	[row_id] [int] NOT NULL,
	[phonenumber] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dnc_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[wireless_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[nxx_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[dnc_wireless_codes] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_phone_dnc_wireless_job_detail] PRIMARY KEY CLUSTERED
(
	[phone_dnc_wireless_job_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [cstd_phone_dnc_wirelss_job_detail_i1] ON [dbo].[cstd_phone_dnc_wireless_job_detail]
(
	[phone_dnc_wireless_job_id] ASC,
	[phonenumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_phone_dnc_dnc_flag_INCL] ON [dbo].[cstd_phone_dnc_wireless_job_detail]
(
	[dnc_flag] ASC
)
INCLUDE([phonenumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_phone_dnc_phonenumber] ON [dbo].[cstd_phone_dnc_wireless_job_detail]
(
	[phonenumber] ASC,
	[dnc_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_phone_dnc_wireless_job_detail]  WITH CHECK ADD  CONSTRAINT [cstd_phone_dnc_wireless_job_detai_cstd_phone_dnc_wireless_job] FOREIGN KEY([phone_dnc_wireless_job_id])
REFERENCES [dbo].[cstd_phone_dnc_wireless_job] ([phone_dnc_wireless_job_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_phone_dnc_wireless_job_detail] CHECK CONSTRAINT [cstd_phone_dnc_wireless_job_detai_cstd_phone_dnc_wireless_job]
GO
