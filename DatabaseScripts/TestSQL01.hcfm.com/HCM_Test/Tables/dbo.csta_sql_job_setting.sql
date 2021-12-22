/* CreateDate: 06/25/2012 10:27:04.873 , ModifyDate: 06/28/2012 09:52:18.173 */
GO
CREATE TABLE [dbo].[csta_sql_job_setting](
	[sql_job_setting_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sql_job_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_value] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_csta_sql_job_setting] PRIMARY KEY CLUSTERED
(
	[sql_job_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_sql_job_setting]  WITH CHECK ADD  CONSTRAINT [FK_csta_sql_job_setting_csta_sql_job] FOREIGN KEY([sql_job_id])
REFERENCES [dbo].[csta_sql_job] ([sql_job_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_sql_job_setting] CHECK CONSTRAINT [FK_csta_sql_job_setting_csta_sql_job]
GO
