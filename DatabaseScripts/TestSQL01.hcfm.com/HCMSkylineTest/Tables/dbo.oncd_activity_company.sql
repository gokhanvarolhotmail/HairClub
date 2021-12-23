/* CreateDate: 11/08/2012 13:51:06.920 , ModifyDate: 11/08/2012 13:51:07.050 */
GO
CREATE TABLE [dbo].[oncd_activity_company](
	[activity_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_company] PRIMARY KEY CLUSTERED
(
	[activity_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [activity_activity_com_139] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [activity_activity_com_139]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [company_activity_com_140] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [company_activity_com_140]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [user_activity_com_453] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [user_activity_com_453]
GO
ALTER TABLE [dbo].[oncd_activity_company]  WITH CHECK ADD  CONSTRAINT [user_activity_com_454] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_company] CHECK CONSTRAINT [user_activity_com_454]
GO
