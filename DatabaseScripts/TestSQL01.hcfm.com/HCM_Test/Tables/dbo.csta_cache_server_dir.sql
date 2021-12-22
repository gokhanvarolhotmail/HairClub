/* CreateDate: 01/25/2010 13:16:24.273 , ModifyDate: 06/21/2012 09:59:49.117 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_cache_server_dir](
	[cache_server_dir_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cache_server_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[base_dir] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[cache_server_dir_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_cache_server_dir]  WITH CHECK ADD  CONSTRAINT [cache_server_dir_cache_server_name] FOREIGN KEY([cache_server_id])
REFERENCES [dbo].[csta_cache_server_name] ([cache_server_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_cache_server_dir] CHECK CONSTRAINT [cache_server_dir_cache_server_name]
GO
