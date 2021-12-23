/* CreateDate: 03/01/2006 08:13:59.523 , ModifyDate: 06/21/2012 10:04:33.303 */
GO
CREATE TABLE [dbo].[oncs_task_server](
	[task_server_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_id] [int] NOT NULL,
	[task_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_oncs_task_server] PRIMARY KEY CLUSTERED
(
	[task_server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_task_server_i1] ON [dbo].[oncs_task_server]
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncs_task_server_i2] ON [dbo].[oncs_task_server]
(
	[server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_task_server_i3] ON [dbo].[oncs_task_server]
(
	[packet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_task_server]  WITH NOCHECK ADD  CONSTRAINT [packet_task_server_429] FOREIGN KEY([packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_task_server] CHECK CONSTRAINT [packet_task_server_429]
GO
ALTER TABLE [dbo].[oncs_task_server]  WITH NOCHECK ADD  CONSTRAINT [server_task_server_426] FOREIGN KEY([server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_task_server] CHECK CONSTRAINT [server_task_server_426]
GO
ALTER TABLE [dbo].[oncs_task_server]  WITH NOCHECK ADD  CONSTRAINT [task_task_server_425] FOREIGN KEY([task_id])
REFERENCES [dbo].[oncs_task] ([task_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_task_server] CHECK CONSTRAINT [task_task_server_425]
GO
