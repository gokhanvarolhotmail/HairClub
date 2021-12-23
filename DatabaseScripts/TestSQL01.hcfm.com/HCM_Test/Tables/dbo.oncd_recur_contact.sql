/* CreateDate: 01/18/2005 09:34:08.263 , ModifyDate: 06/21/2012 10:04:53.443 */
GO
CREATE TABLE [dbo].[oncd_recur_contact](
	[recur_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_recur_contact] PRIMARY KEY CLUSTERED
(
	[recur_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_contact_i2] ON [dbo].[oncd_recur_contact]
(
	[recur_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_contact_i3] ON [dbo].[oncd_recur_contact]
(
	[contact_id] ASC,
	[recur_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_recur_contact]  WITH NOCHECK ADD  CONSTRAINT [contact_recur_contac_109] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_recur_contact] CHECK CONSTRAINT [contact_recur_contac_109]
GO
ALTER TABLE [dbo].[oncd_recur_contact]  WITH NOCHECK ADD  CONSTRAINT [recur_recur_contac_213] FOREIGN KEY([recur_id])
REFERENCES [dbo].[oncd_recur] ([recur_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_recur_contact] CHECK CONSTRAINT [recur_recur_contac_213]
GO
ALTER TABLE [dbo].[oncd_recur_contact]  WITH NOCHECK ADD  CONSTRAINT [user_recur_contac_480] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_contact] CHECK CONSTRAINT [user_recur_contac_480]
GO
ALTER TABLE [dbo].[oncd_recur_contact]  WITH NOCHECK ADD  CONSTRAINT [user_recur_contac_481] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_contact] CHECK CONSTRAINT [user_recur_contac_481]
GO
