/* CreateDate: 10/10/2011 15:19:05.753 , ModifyDate: 09/10/2019 22:49:39.300 */
GO
CREATE TABLE [dbo].[cstd_sql_job_log](
	[sql_job_log_id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[message_date] [datetime] NULL,
	[message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_sql_job_log] PRIMARY KEY CLUSTERED
(
	[sql_job_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_sql_job_log] ADD  CONSTRAINT [DF_cstd_sql_job_log_message_date]  DEFAULT (getdate()) FOR [message_date]
GO
