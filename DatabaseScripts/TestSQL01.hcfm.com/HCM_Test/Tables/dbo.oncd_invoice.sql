/* CreateDate: 01/25/2010 11:09:09.850 , ModifyDate: 06/21/2012 10:05:24.087 */
GO
CREATE TABLE [dbo].[oncd_invoice](
	[invoice_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[external_invoice_id] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[invoice_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_invoice] PRIMARY KEY CLUSTERED
(
	[invoice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_i2] ON [dbo].[oncd_invoice]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_i3] ON [dbo].[oncd_invoice]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_i4_] ON [dbo].[oncd_invoice]
(
	[invoice_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_invoice]  WITH CHECK ADD  CONSTRAINT [company_invoice_961] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_invoice] CHECK CONSTRAINT [company_invoice_961]
GO
ALTER TABLE [dbo].[oncd_invoice]  WITH CHECK ADD  CONSTRAINT [contact_invoice_962] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_invoice] CHECK CONSTRAINT [contact_invoice_962]
GO
ALTER TABLE [dbo].[oncd_invoice]  WITH CHECK ADD  CONSTRAINT [invoice_stat_invoice_1078] FOREIGN KEY([invoice_status_code])
REFERENCES [dbo].[onca_invoice_status] ([invoice_status_code])
GO
ALTER TABLE [dbo].[oncd_invoice] CHECK CONSTRAINT [invoice_stat_invoice_1078]
GO
ALTER TABLE [dbo].[oncd_invoice]  WITH CHECK ADD  CONSTRAINT [user_invoice_963] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice] CHECK CONSTRAINT [user_invoice_963]
GO
ALTER TABLE [dbo].[oncd_invoice]  WITH CHECK ADD  CONSTRAINT [user_invoice_964] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice] CHECK CONSTRAINT [user_invoice_964]
GO
ALTER TABLE [dbo].[oncd_invoice]  WITH CHECK ADD  CONSTRAINT [user_invoice_965] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice] CHECK CONSTRAINT [user_invoice_965]
GO
