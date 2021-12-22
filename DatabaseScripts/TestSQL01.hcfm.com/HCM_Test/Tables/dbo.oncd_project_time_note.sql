/* CreateDate: 01/25/2010 11:09:10.037 , ModifyDate: 06/21/2012 10:05:10.317 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_project_time_note](
	[project_time_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_project_time_note] PRIMARY KEY CLUSTERED
(
	[project_time_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_time_note]  WITH CHECK ADD  CONSTRAINT [project_time_project_time_783] FOREIGN KEY([project_time_id])
REFERENCES [dbo].[oncd_project_time] ([project_time_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_time_note] CHECK CONSTRAINT [project_time_project_time_783]
GO
ALTER TABLE [dbo].[oncd_project_time_note]  WITH CHECK ADD  CONSTRAINT [user_project_time_1062] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_time_note] CHECK CONSTRAINT [user_project_time_1062]
GO
ALTER TABLE [dbo].[oncd_project_time_note]  WITH CHECK ADD  CONSTRAINT [user_project_time_1063] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_time_note] CHECK CONSTRAINT [user_project_time_1063]
GO
