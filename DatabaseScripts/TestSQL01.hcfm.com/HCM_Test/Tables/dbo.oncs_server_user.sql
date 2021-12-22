/* CreateDate: 01/18/2005 09:34:19.513 , ModifyDate: 06/21/2012 10:04:45.677 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_server_user](
	[server_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_id] [int] NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_server_user] PRIMARY KEY CLUSTERED
(
	[server_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_server_user]  WITH CHECK ADD  CONSTRAINT [server_server_user_306] FOREIGN KEY([server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_server_user] CHECK CONSTRAINT [server_server_user_306]
GO
ALTER TABLE [dbo].[oncs_server_user]  WITH CHECK ADD  CONSTRAINT [user_server_user_890] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncs_server_user] CHECK CONSTRAINT [user_server_user_890]
GO
