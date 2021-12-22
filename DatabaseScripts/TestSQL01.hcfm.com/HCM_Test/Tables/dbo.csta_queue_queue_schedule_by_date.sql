/* CreateDate: 10/15/2013 00:47:40.107 , ModifyDate: 05/19/2014 08:48:36.153 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_queue_queue_schedule_by_date](
	[queue_queue_schedule_by_date_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_schedule_by_date_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
 CONSTRAINT [PK_csta_queue_queue_schedule_by_date] PRIMARY KEY CLUSTERED
(
	[queue_queue_schedule_by_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [csta_queue_queue_schedule_by_date_i2] ON [dbo].[csta_queue_queue_schedule_by_date]
(
	[queue_id] ASC,
	[queue_schedule_by_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date] ADD  CONSTRAINT [DF_csta_queue_queue_schedule_by_date_active]  DEFAULT (N'Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_date_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_date_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_date_csta_queue] FOREIGN KEY([queue_id])
REFERENCES [dbo].[csta_queue] ([queue_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_date_csta_queue]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_date_csta_queue_schedule_by_date] FOREIGN KEY([queue_schedule_by_date_id])
REFERENCES [dbo].[csta_queue_schedule_by_date] ([queue_schedule_by_date_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_date_csta_queue_schedule_by_date]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_date_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_date] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_date_updated_by_user]
GO
