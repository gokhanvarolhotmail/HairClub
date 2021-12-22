/* CreateDate: 01/18/2005 09:34:09.047 , ModifyDate: 06/21/2012 10:08:16.730 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_contact_relation](
	[contact_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_relation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_relation] PRIMARY KEY CLUSTERED
(
	[contact_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_relation]  WITH CHECK ADD  CONSTRAINT [contact_rela_contact_rela_612] FOREIGN KEY([contact_relation_code])
REFERENCES [dbo].[onca_contact_relation] ([contact_relation_code])
GO
ALTER TABLE [dbo].[oncd_contact_relation] CHECK CONSTRAINT [contact_rela_contact_rela_612]
GO
ALTER TABLE [dbo].[oncd_contact_relation]  WITH CHECK ADD  CONSTRAINT [user_contact_rela_610] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_relation] CHECK CONSTRAINT [user_contact_rela_610]
GO
ALTER TABLE [dbo].[oncd_contact_relation]  WITH CHECK ADD  CONSTRAINT [user_contact_rela_611] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_relation] CHECK CONSTRAINT [user_contact_rela_611]
GO
