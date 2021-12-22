/* CreateDate: 03/22/2016 11:02:14.603 , ModifyDate: 03/22/2016 11:02:14.660 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_phone_dnc_wireless_job](
	[phone_dnc_wireless_job_id] [uniqueidentifier] NOT NULL,
	[export_date] [datetime] NULL,
	[exported_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[import_date] [datetime] NULL,
	[imported_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_phone_dnc_wireless_job] PRIMARY KEY CLUSTERED
(
	[phone_dnc_wireless_job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_phone_dnc_wireless_job]  WITH CHECK ADD  CONSTRAINT [cstd_phone_dnc_wireless_job_onca_user_1] FOREIGN KEY([exported_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_phone_dnc_wireless_job] CHECK CONSTRAINT [cstd_phone_dnc_wireless_job_onca_user_1]
GO
ALTER TABLE [dbo].[cstd_phone_dnc_wireless_job]  WITH CHECK ADD  CONSTRAINT [cstd_phone_dnc_wireless_job_onca_user_2] FOREIGN KEY([imported_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_phone_dnc_wireless_job] CHECK CONSTRAINT [cstd_phone_dnc_wireless_job_onca_user_2]
GO
