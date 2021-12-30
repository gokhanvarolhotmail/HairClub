/* CreateDate: 01/18/2005 09:34:19.483 , ModifyDate: 06/21/2012 10:04:45.607 */
GO
CREATE TABLE [dbo].[oncs_server_publication](
	[server_publication_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_id] [int] NOT NULL,
	[publication_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_server_publication] PRIMARY KEY CLUSTERED
(
	[server_publication_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_server_publication]  WITH CHECK ADD  CONSTRAINT [publication_server_publi_314] FOREIGN KEY([publication_id])
REFERENCES [dbo].[oncs_publication] ([publication_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_server_publication] CHECK CONSTRAINT [publication_server_publi_314]
GO
ALTER TABLE [dbo].[oncs_server_publication]  WITH CHECK ADD  CONSTRAINT [server_server_publi_315] FOREIGN KEY([server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_server_publication] CHECK CONSTRAINT [server_server_publi_315]
GO
