/* CreateDate: 06/01/2005 12:54:54.737 , ModifyDate: 06/21/2012 10:04:45.403 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_packet](
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_server_id] [int] NOT NULL,
	[destination_server_id] [int] NOT NULL,
	[packet_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[processed_date] [datetime] NULL,
	[acknowledged_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_packet] PRIMARY KEY CLUSTERED
(
	[packet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_packet_i2] ON [dbo].[oncs_packet]
(
	[parent_packet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_packet_i4] ON [dbo].[oncs_packet]
(
	[packet_status_code] ASC,
	[acknowledged_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_packet_i5] ON [dbo].[oncs_packet]
(
	[destination_server_id] ASC,
	[packet_status_code] ASC,
	[acknowledged_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_packet]  WITH CHECK ADD  CONSTRAINT [packet_packet_379] FOREIGN KEY([parent_packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
GO
ALTER TABLE [dbo].[oncs_packet] CHECK CONSTRAINT [packet_packet_379]
GO
ALTER TABLE [dbo].[oncs_packet]  WITH CHECK ADD  CONSTRAINT [server_packet_880] FOREIGN KEY([creation_server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
GO
ALTER TABLE [dbo].[oncs_packet] CHECK CONSTRAINT [server_packet_880]
GO
ALTER TABLE [dbo].[oncs_packet]  WITH CHECK ADD  CONSTRAINT [server_packet_881] FOREIGN KEY([destination_server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
GO
ALTER TABLE [dbo].[oncs_packet] CHECK CONSTRAINT [server_packet_881]
GO
