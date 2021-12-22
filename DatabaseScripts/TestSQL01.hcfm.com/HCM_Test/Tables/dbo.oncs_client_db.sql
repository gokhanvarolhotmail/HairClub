/* CreateDate: 06/06/2005 17:18:56.973 , ModifyDate: 06/21/2012 10:04:45.340 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_client_db](
	[client_db_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_db_profile] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[server_destination_dir] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_db_profile] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_data_file_path] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[client_log_file_path] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_client_db] PRIMARY KEY CLUSTERED
(
	[client_db_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
