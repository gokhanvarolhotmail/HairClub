/* CreateDate: 01/25/2010 11:09:09.630 , ModifyDate: 06/21/2012 10:05:24.160 */
GO
CREATE TABLE [dbo].[oncd_invoice_time](
	[invoice_time_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_time_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[invoice_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[approved_date] [datetime] NULL,
	[approved_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_invoice_time] PRIMARY KEY CLUSTERED
(
	[invoice_time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_time_i2_] ON [dbo].[oncd_invoice_time]
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_time_i3] ON [dbo].[oncd_invoice_time]
(
	[project_time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_invoice_time]  WITH CHECK ADD  CONSTRAINT [invoice_invoice_time_738] FOREIGN KEY([invoice_id])
REFERENCES [dbo].[oncd_invoice] ([invoice_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_invoice_time] CHECK CONSTRAINT [invoice_invoice_time_738]
GO
ALTER TABLE [dbo].[oncd_invoice_time]  WITH CHECK ADD  CONSTRAINT [project_time_invoice_time_782] FOREIGN KEY([project_time_id])
REFERENCES [dbo].[oncd_project_time] ([project_time_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_invoice_time] CHECK CONSTRAINT [project_time_invoice_time_782]
GO
ALTER TABLE [dbo].[oncd_invoice_time]  WITH CHECK ADD  CONSTRAINT [user_invoice_time_1147] FOREIGN KEY([approved_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_time] CHECK CONSTRAINT [user_invoice_time_1147]
GO
ALTER TABLE [dbo].[oncd_invoice_time]  WITH CHECK ADD  CONSTRAINT [user_invoice_time_970] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_time] CHECK CONSTRAINT [user_invoice_time_970]
GO
ALTER TABLE [dbo].[oncd_invoice_time]  WITH CHECK ADD  CONSTRAINT [user_invoice_time_971] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_time] CHECK CONSTRAINT [user_invoice_time_971]
GO
