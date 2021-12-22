/* CreateDate: 06/01/2005 13:05:19.747 , ModifyDate: 10/23/2017 12:35:14.790 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_knowledge_note](
	[knowledge_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_knowledge_note] PRIMARY KEY CLUSTERED
(
	[knowledge_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_knowledge_note]  WITH CHECK ADD  CONSTRAINT [knowledge_knowledge_no_207] FOREIGN KEY([knowledge_id])
REFERENCES [dbo].[oncd_knowledge] ([knowledge_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_knowledge_note] CHECK CONSTRAINT [knowledge_knowledge_no_207]
GO
ALTER TABLE [dbo].[oncd_knowledge_note]  WITH CHECK ADD  CONSTRAINT [user_knowledge_no_671] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_knowledge_note] CHECK CONSTRAINT [user_knowledge_no_671]
GO
ALTER TABLE [dbo].[oncd_knowledge_note]  WITH CHECK ADD  CONSTRAINT [user_knowledge_no_672] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_knowledge_note] CHECK CONSTRAINT [user_knowledge_no_672]
GO
