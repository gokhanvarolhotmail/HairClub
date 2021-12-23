/* CreateDate: 01/18/2005 09:34:10.280 , ModifyDate: 06/21/2012 10:01:00.463 */
GO
CREATE TABLE [dbo].[onca_group_document](
	[group_document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[document_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_document] PRIMARY KEY CLUSTERED
(
	[group_document_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_document]  WITH NOCHECK ADD  CONSTRAINT [document_gro_group_docume_236] FOREIGN KEY([document_group_id])
REFERENCES [dbo].[onca_document_group] ([document_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_document] CHECK CONSTRAINT [document_gro_group_docume_236]
GO
ALTER TABLE [dbo].[onca_group_document]  WITH NOCHECK ADD  CONSTRAINT [group_group_docume_233] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_document] CHECK CONSTRAINT [group_group_docume_233]
GO
