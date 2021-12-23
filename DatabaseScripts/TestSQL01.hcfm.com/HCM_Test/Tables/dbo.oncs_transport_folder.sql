/* CreateDate: 01/18/2005 09:34:19.810 , ModifyDate: 06/21/2012 10:04:33.460 */
GO
CREATE TABLE [dbo].[oncs_transport_folder](
	[transport_folder_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transport_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[folder_url] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transport_folder] PRIMARY KEY CLUSTERED
(
	[transport_folder_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transport_folder]  WITH CHECK ADD  CONSTRAINT [transport_transport_fo_316] FOREIGN KEY([transport_id])
REFERENCES [dbo].[oncs_transport] ([transport_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transport_folder] CHECK CONSTRAINT [transport_transport_fo_316]
GO
