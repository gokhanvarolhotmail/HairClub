/* CreateDate: 01/25/2010 11:09:09.630 , ModifyDate: 06/21/2012 10:05:24.160 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_invoice_time_adjust](
	[invoice_time_adjust_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[invoice_time_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[invoice_time_adjust_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[adjust_time] [int] NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_invoice_time_adjust] PRIMARY KEY CLUSTERED
(
	[invoice_time_adjust_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_invoice_time_adjust_i2] ON [dbo].[oncd_invoice_time_adjust]
(
	[invoice_time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust]  WITH CHECK ADD  CONSTRAINT [invoice_time_invoice_time_740] FOREIGN KEY([invoice_time_id])
REFERENCES [dbo].[oncd_invoice_time] ([invoice_time_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust] CHECK CONSTRAINT [invoice_time_invoice_time_740]
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust]  WITH CHECK ADD  CONSTRAINT [user_invoice_time_972] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust] CHECK CONSTRAINT [user_invoice_time_972]
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust]  WITH CHECK ADD  CONSTRAINT [user_invoice_time_973] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust] CHECK CONSTRAINT [user_invoice_time_973]
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust]  WITH CHECK ADD  CONSTRAINT [user_invoice_time_974] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_invoice_time_adjust] CHECK CONSTRAINT [user_invoice_time_974]
GO
