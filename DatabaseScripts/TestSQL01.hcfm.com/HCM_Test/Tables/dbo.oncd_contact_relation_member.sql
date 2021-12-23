/* CreateDate: 01/18/2005 09:34:09.060 , ModifyDate: 06/21/2012 10:08:16.740 */
GO
CREATE TABLE [dbo].[oncd_contact_relation_member](
	[contact_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_member_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_relation_member] PRIMARY KEY CLUSTERED
(
	[contact_relation_member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_relation_memb_i02] ON [dbo].[oncd_contact_relation_member]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_relation_memb_i03] ON [dbo].[oncd_contact_relation_member]
(
	[contact_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_relation_member]  WITH CHECK ADD  CONSTRAINT [contact_contact_rela_113] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_relation_member] CHECK CONSTRAINT [contact_contact_rela_113]
GO
ALTER TABLE [dbo].[oncd_contact_relation_member]  WITH CHECK ADD  CONSTRAINT [contact_memb_contact_rela_615] FOREIGN KEY([contact_member_code])
REFERENCES [dbo].[onca_contact_member] ([contact_member_code])
GO
ALTER TABLE [dbo].[oncd_contact_relation_member] CHECK CONSTRAINT [contact_memb_contact_rela_615]
GO
ALTER TABLE [dbo].[oncd_contact_relation_member]  WITH CHECK ADD  CONSTRAINT [contact_rela_contact_rela_112] FOREIGN KEY([contact_relation_id])
REFERENCES [dbo].[oncd_contact_relation] ([contact_relation_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_relation_member] CHECK CONSTRAINT [contact_rela_contact_rela_112]
GO
ALTER TABLE [dbo].[oncd_contact_relation_member]  WITH CHECK ADD  CONSTRAINT [user_contact_rela_613] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_relation_member] CHECK CONSTRAINT [user_contact_rela_613]
GO
ALTER TABLE [dbo].[oncd_contact_relation_member]  WITH CHECK ADD  CONSTRAINT [user_contact_rela_614] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_relation_member] CHECK CONSTRAINT [user_contact_rela_614]
GO
