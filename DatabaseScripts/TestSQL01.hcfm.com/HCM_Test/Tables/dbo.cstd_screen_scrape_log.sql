/* CreateDate: 06/19/2013 14:11:28.100 , ModifyDate: 09/10/2019 22:38:57.603 */
GO
CREATE TABLE [dbo].[cstd_screen_scrape_log](
	[screen_scrape_log_id] [int] IDENTITY(1,1) NOT NULL,
	[log_date] [datetime] NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_screen_scrape_log] PRIMARY KEY CLUSTERED
(
	[screen_scrape_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_screen_scrape_log] ADD  CONSTRAINT [DF_cstd_screen_scrape_log_log_date]  DEFAULT (getdate()) FOR [log_date]
GO
