/* CreateDate: 01/25/2010 11:09:09.803 , ModifyDate: 06/21/2012 10:05:10.087 */
GO
CREATE TABLE [dbo].[oncd_project_note](
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_note] PRIMARY KEY CLUSTERED
(
	[project_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_note]  WITH NOCHECK ADD  CONSTRAINT [project_project_note_746] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_note] CHECK CONSTRAINT [project_project_note_746]
GO
ALTER TABLE [dbo].[oncd_project_note]  WITH NOCHECK ADD  CONSTRAINT [user_project_note_1021] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_note] CHECK CONSTRAINT [user_project_note_1021]
GO
ALTER TABLE [dbo].[oncd_project_note]  WITH NOCHECK ADD  CONSTRAINT [user_project_note_1022] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_note] CHECK CONSTRAINT [user_project_note_1022]
GO
