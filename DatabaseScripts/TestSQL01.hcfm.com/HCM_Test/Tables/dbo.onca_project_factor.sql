/* CreateDate: 01/25/2010 11:09:09.787 , ModifyDate: 06/21/2012 10:00:47.013 */
GO
CREATE TABLE [dbo].[onca_project_factor](
	[project_factor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[factor] [int] NOT NULL,
	[factor_type_flag] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[project_task_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_project_factor] PRIMARY KEY CLUSTERED
(
	[project_factor_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_project_factor]  WITH NOCHECK ADD  CONSTRAINT [project_task_project_fact_734] FOREIGN KEY([project_task_code])
REFERENCES [dbo].[onca_project_task] ([project_task_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_project_factor] CHECK CONSTRAINT [project_task_project_fact_734]
GO
