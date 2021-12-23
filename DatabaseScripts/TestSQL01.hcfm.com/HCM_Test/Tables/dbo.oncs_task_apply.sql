/* CreateDate: 03/01/2006 08:13:59.540 , ModifyDate: 06/21/2012 10:04:33.283 */
GO
CREATE TABLE [dbo].[oncs_task_apply](
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
	[task_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[acknowledged_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_oncs_packet_task_apply] PRIMARY KEY CLUSTERED
(
	[packet_id] ASC,
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_task_apply_i1] ON [dbo].[oncs_task_apply]
(
	[task_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_task_apply]  WITH NOCHECK ADD  CONSTRAINT [packet_task_apply_427] FOREIGN KEY([packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_task_apply] CHECK CONSTRAINT [packet_task_apply_427]
GO
ALTER TABLE [dbo].[oncs_task_apply]  WITH NOCHECK ADD  CONSTRAINT [task_task_apply_893] FOREIGN KEY([task_id])
REFERENCES [dbo].[oncs_task] ([task_id])
GO
ALTER TABLE [dbo].[oncs_task_apply] CHECK CONSTRAINT [task_task_apply_893]
GO
