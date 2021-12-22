/* CreateDate: 01/18/2005 09:34:19.903 , ModifyDate: 06/21/2012 10:04:33.463 */
GO
CREATE TABLE [dbo].[oncs_transport_http](
	[transport_http_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transport_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[site_address] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_value] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transport_http] PRIMARY KEY CLUSTERED
(
	[transport_http_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transport_http]  WITH CHECK ADD  CONSTRAINT [transport_transport_ht_317] FOREIGN KEY([transport_id])
REFERENCES [dbo].[oncs_transport] ([transport_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transport_http] CHECK CONSTRAINT [transport_transport_ht_317]
GO
