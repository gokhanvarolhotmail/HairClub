/* CreateDate: 01/18/2005 09:34:08.187 , ModifyDate: 06/21/2012 10:21:54.117 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_activity_enclosure](
	[activity_enclosure_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[enclosure_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quantity] [int] NULL,
	[cost] [decimal](15, 4) NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_activity_enclosure] PRIMARY KEY CLUSTERED
(
	[activity_enclosure_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_activity_enclosure_i2] ON [dbo].[oncd_activity_enclosure]
(
	[activity_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_activity_enclosure]  WITH CHECK ADD  CONSTRAINT [activity_activity_enc_99] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_activity_enclosure] CHECK CONSTRAINT [activity_activity_enc_99]
GO
ALTER TABLE [dbo].[oncd_activity_enclosure]  WITH CHECK ADD  CONSTRAINT [enclosure_activity_enc_462] FOREIGN KEY([enclosure_code])
REFERENCES [dbo].[onca_enclosure] ([enclosure_code])
GO
ALTER TABLE [dbo].[oncd_activity_enclosure] CHECK CONSTRAINT [enclosure_activity_enc_462]
GO
ALTER TABLE [dbo].[oncd_activity_enclosure]  WITH CHECK ADD  CONSTRAINT [user_activity_enc_460] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_enclosure] CHECK CONSTRAINT [user_activity_enc_460]
GO
ALTER TABLE [dbo].[oncd_activity_enclosure]  WITH CHECK ADD  CONSTRAINT [user_activity_enc_461] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_activity_enclosure] CHECK CONSTRAINT [user_activity_enc_461]
GO
