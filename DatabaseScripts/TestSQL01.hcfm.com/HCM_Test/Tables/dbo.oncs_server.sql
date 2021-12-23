/* CreateDate: 07/13/2005 16:58:17.990 , ModifyDate: 06/21/2012 10:04:45.603 */
GO
CREATE TABLE [dbo].[oncs_server](
	[server_id] [int] NOT NULL,
	[transport_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_applied_packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_extracted_packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_active_for_audit] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_active_for_extract] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_folder] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_offset] [float] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[clear_transaction_flag] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[audit_applied_flag] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_server] PRIMARY KEY CLUSTERED
(
	[server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_server_i2] ON [dbo].[oncs_server]
(
	[is_active_for_extract] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_server]  WITH CHECK ADD  CONSTRAINT [packet_server_391] FOREIGN KEY([last_applied_packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
GO
ALTER TABLE [dbo].[oncs_server] CHECK CONSTRAINT [packet_server_391]
GO
ALTER TABLE [dbo].[oncs_server]  WITH CHECK ADD  CONSTRAINT [packet_server_395] FOREIGN KEY([last_extracted_packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
GO
ALTER TABLE [dbo].[oncs_server] CHECK CONSTRAINT [packet_server_395]
GO
ALTER TABLE [dbo].[oncs_server]  WITH CHECK ADD  CONSTRAINT [transport_server_313] FOREIGN KEY([transport_id])
REFERENCES [dbo].[oncs_transport] ([transport_id])
GO
ALTER TABLE [dbo].[oncs_server] CHECK CONSTRAINT [transport_server_313]
GO
