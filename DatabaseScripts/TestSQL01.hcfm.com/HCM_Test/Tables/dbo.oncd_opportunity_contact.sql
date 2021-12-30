/* CreateDate: 01/18/2005 09:34:09.513 , ModifyDate: 06/21/2012 10:05:17.857 */
GO
CREATE TABLE [dbo].[oncd_opportunity_contact](
	[opportunity_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
 CONSTRAINT [pk_oncd_opportunity_contact] PRIMARY KEY CLUSTERED
(
	[opportunity_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_contact_i2] ON [dbo].[oncd_opportunity_contact]
(
	[opportunity_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_contact_i3] ON [dbo].[oncd_opportunity_contact]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity_contact]  WITH CHECK ADD  CONSTRAINT [contact_opportunity__332] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_contact] CHECK CONSTRAINT [contact_opportunity__332]
GO
ALTER TABLE [dbo].[oncd_opportunity_contact]  WITH CHECK ADD  CONSTRAINT [opportunity__opportunity__686] FOREIGN KEY([opportunity_role_code])
REFERENCES [dbo].[onca_opportunity_role] ([opportunity_role_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_contact] CHECK CONSTRAINT [opportunity__opportunity__686]
GO
ALTER TABLE [dbo].[oncd_opportunity_contact]  WITH CHECK ADD  CONSTRAINT [opportunity_opportunity__151] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_contact] CHECK CONSTRAINT [opportunity_opportunity__151]
GO
ALTER TABLE [dbo].[oncd_opportunity_contact]  WITH CHECK ADD  CONSTRAINT [user_opportunity__687] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_contact] CHECK CONSTRAINT [user_opportunity__687]
GO
ALTER TABLE [dbo].[oncd_opportunity_contact]  WITH CHECK ADD  CONSTRAINT [user_opportunity__688] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_contact] CHECK CONSTRAINT [user_opportunity__688]
GO
