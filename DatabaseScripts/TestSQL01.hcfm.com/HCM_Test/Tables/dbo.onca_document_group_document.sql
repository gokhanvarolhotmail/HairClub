/* CreateDate: 01/18/2005 09:34:10.233 , ModifyDate: 06/21/2012 10:01:04.813 */
GO
CREATE TABLE [dbo].[onca_document_group_document](
	[document_group_document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[document_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_document_group_document] PRIMARY KEY CLUSTERED
(
	[document_group_document_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_document_group_document]  WITH NOCHECK ADD  CONSTRAINT [document_document_gro_240] FOREIGN KEY([document_id])
REFERENCES [dbo].[onca_document] ([document_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_document_group_document] CHECK CONSTRAINT [document_document_gro_240]
GO
ALTER TABLE [dbo].[onca_document_group_document]  WITH NOCHECK ADD  CONSTRAINT [document_gro_document_gro_239] FOREIGN KEY([document_group_id])
REFERENCES [dbo].[onca_document_group] ([document_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_document_group_document] CHECK CONSTRAINT [document_gro_document_gro_239]
GO