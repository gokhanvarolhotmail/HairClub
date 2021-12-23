/* CreateDate: 01/25/2010 11:09:09.770 , ModifyDate: 06/21/2012 10:05:10.090 */
GO
CREATE TABLE [dbo].[oncd_project_revision](
	[project_revision_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[revision_date] [datetime] NOT NULL,
	[project_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncd_project_revision] PRIMARY KEY CLUSTERED
(
	[project_revision_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_project_revision]  WITH NOCHECK ADD  CONSTRAINT [project_project_revi_747] FOREIGN KEY([project_id])
REFERENCES [dbo].[oncd_project] ([project_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_project_revision] CHECK CONSTRAINT [project_project_revi_747]
GO
ALTER TABLE [dbo].[oncd_project_revision]  WITH NOCHECK ADD  CONSTRAINT [user_project_revi_1023] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_project_revision] CHECK CONSTRAINT [user_project_revi_1023]
GO
