/* CreateDate: 01/18/2005 09:34:14.483 , ModifyDate: 06/21/2012 10:05:24.173 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_knowledge_attachment](
	[attachment_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[file_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[storage_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncd_knowledge_attachment] PRIMARY KEY CLUSTERED
(
	[attachment_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_knowledge_attachment_i2] ON [dbo].[oncd_knowledge_attachment]
(
	[knowledge_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_knowledge_attachment]  WITH CHECK ADD  CONSTRAINT [knowledge_knowledge_at_205] FOREIGN KEY([knowledge_id])
REFERENCES [dbo].[oncd_knowledge] ([knowledge_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_knowledge_attachment] CHECK CONSTRAINT [knowledge_knowledge_at_205]
GO
ALTER TABLE [dbo].[oncd_knowledge_attachment]  WITH CHECK ADD  CONSTRAINT [user_knowledge_at_669] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_knowledge_attachment] CHECK CONSTRAINT [user_knowledge_at_669]
GO
ALTER TABLE [dbo].[oncd_knowledge_attachment]  WITH CHECK ADD  CONSTRAINT [user_knowledge_at_670] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_knowledge_attachment] CHECK CONSTRAINT [user_knowledge_at_670]
GO
