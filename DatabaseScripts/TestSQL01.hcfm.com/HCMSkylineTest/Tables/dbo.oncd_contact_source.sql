/* CreateDate: 11/08/2012 13:46:47.943 , ModifyDate: 07/11/2017 10:53:35.627 */
GO
CREATE TABLE [dbo].[oncd_contact_source](
	[contact_source_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[media_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnis_number] [int] NULL,
	[cst_sub_source_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_source] PRIMARY KEY CLUSTERED
(
	[contact_source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_source_i2] ON [dbo].[oncd_contact_source]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([source_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_sour_70] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [contact_contact_sour_70]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH NOCHECK ADD  CONSTRAINT [media_contact_sour_618] FOREIGN KEY([media_code])
REFERENCES [dbo].[onca_media] ([media_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [media_contact_sour_618]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH NOCHECK ADD  CONSTRAINT [source_contact_sour_619] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [source_contact_sour_619]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH NOCHECK ADD  CONSTRAINT [user_contact_sour_616] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [user_contact_sour_616]
GO
ALTER TABLE [dbo].[oncd_contact_source]  WITH NOCHECK ADD  CONSTRAINT [user_contact_sour_617] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_source] CHECK CONSTRAINT [user_contact_sour_617]
GO
