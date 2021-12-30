/* CreateDate: 06/25/2012 10:27:04.783 , ModifyDate: 06/28/2012 09:52:18.173 */
GO
CREATE TABLE [dbo].[csta_sql_job](
	[sql_job_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_sql_job] PRIMARY KEY CLUSTERED
(
	[sql_job_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_sql_job] ADD  CONSTRAINT [DF_csta_sql_job_active]  DEFAULT ('Y') FOR [active]
GO
