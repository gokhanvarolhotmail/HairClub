/* CreateDate: 01/18/2005 09:34:19.857 , ModifyDate: 06/21/2012 10:04:33.463 */
GO
CREATE TABLE [dbo].[oncs_transport_ftp](
	[transport_ftp_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transport_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[site_address] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[root_folder] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_value] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transport_ftp] PRIMARY KEY CLUSTERED
(
	[transport_ftp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transport_ftp]  WITH CHECK ADD  CONSTRAINT [transport_transport_ft_318] FOREIGN KEY([transport_id])
REFERENCES [dbo].[oncs_transport] ([transport_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transport_ftp] CHECK CONSTRAINT [transport_transport_ft_318]
GO
