/* CreateDate: 01/18/2005 09:34:09.860 , ModifyDate: 06/21/2012 10:04:53.540 */
GO
CREATE TABLE [dbo].[oncd_recur_enclosure](
	[recur_enclosure_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[enclosure_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quantity] [int] NULL,
	[cost] [decimal](15, 4) NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_recur_enclosure] PRIMARY KEY CLUSTERED
(
	[recur_enclosure_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_enclosure_i2] ON [dbo].[oncd_recur_enclosure]
(
	[recur_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_recur_enclosure]  WITH NOCHECK ADD  CONSTRAINT [enclosure_recur_enclos_487] FOREIGN KEY([enclosure_code])
REFERENCES [dbo].[onca_enclosure] ([enclosure_code])
GO
ALTER TABLE [dbo].[oncd_recur_enclosure] CHECK CONSTRAINT [enclosure_recur_enclos_487]
GO
ALTER TABLE [dbo].[oncd_recur_enclosure]  WITH NOCHECK ADD  CONSTRAINT [recur_recur_enclos_210] FOREIGN KEY([recur_id])
REFERENCES [dbo].[oncd_recur] ([recur_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_recur_enclosure] CHECK CONSTRAINT [recur_recur_enclos_210]
GO
ALTER TABLE [dbo].[oncd_recur_enclosure]  WITH NOCHECK ADD  CONSTRAINT [user_recur_enclos_485] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_enclosure] CHECK CONSTRAINT [user_recur_enclos_485]
GO
ALTER TABLE [dbo].[oncd_recur_enclosure]  WITH NOCHECK ADD  CONSTRAINT [user_recur_enclos_486] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_enclosure] CHECK CONSTRAINT [user_recur_enclos_486]
GO
