/* CreateDate: 01/18/2005 09:34:09.953 , ModifyDate: 09/26/2013 14:54:44.840 */
GO
CREATE TABLE [dbo].[onca_document](
	[document_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_activity] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_attachment] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[create_activity_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_document] PRIMARY KEY CLUSTERED
(
	[document_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_document]  WITH NOCHECK ADD  CONSTRAINT [action_document_829] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
GO
ALTER TABLE [dbo].[onca_document] CHECK CONSTRAINT [action_document_829]
GO
ALTER TABLE [dbo].[onca_document]  WITH NOCHECK ADD  CONSTRAINT [entity_document_1179] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
GO
ALTER TABLE [dbo].[onca_document] CHECK CONSTRAINT [entity_document_1179]
GO
ALTER TABLE [dbo].[onca_document]  WITH NOCHECK ADD  CONSTRAINT [object_document_290] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onca_document] CHECK CONSTRAINT [object_document_290]
GO
