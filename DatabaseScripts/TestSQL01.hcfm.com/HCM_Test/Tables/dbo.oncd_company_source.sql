/* CreateDate: 01/18/2005 09:34:08.703 , ModifyDate: 06/21/2012 10:10:43.653 */
GO
CREATE TABLE [dbo].[oncd_company_source](
	[company_source_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[media_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_source] PRIMARY KEY CLUSTERED
(
	[company_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_source_i2] ON [dbo].[oncd_company_source]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_source_i3] ON [dbo].[oncd_company_source]
(
	[source_code] ASC,
	[media_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_source_i4] ON [dbo].[oncd_company_source]
(
	[media_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_source]  WITH CHECK ADD  CONSTRAINT [company_company_sour_82] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_source] CHECK CONSTRAINT [company_company_sour_82]
GO
ALTER TABLE [dbo].[oncd_company_source]  WITH CHECK ADD  CONSTRAINT [media_company_sour_551] FOREIGN KEY([media_code])
REFERENCES [dbo].[onca_media] ([media_code])
GO
ALTER TABLE [dbo].[oncd_company_source] CHECK CONSTRAINT [media_company_sour_551]
GO
ALTER TABLE [dbo].[oncd_company_source]  WITH CHECK ADD  CONSTRAINT [source_company_sour_550] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[oncd_company_source] CHECK CONSTRAINT [source_company_sour_550]
GO
ALTER TABLE [dbo].[oncd_company_source]  WITH CHECK ADD  CONSTRAINT [user_company_sour_552] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_source] CHECK CONSTRAINT [user_company_sour_552]
GO
ALTER TABLE [dbo].[oncd_company_source]  WITH CHECK ADD  CONSTRAINT [user_company_sour_553] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_source] CHECK CONSTRAINT [user_company_sour_553]
GO
