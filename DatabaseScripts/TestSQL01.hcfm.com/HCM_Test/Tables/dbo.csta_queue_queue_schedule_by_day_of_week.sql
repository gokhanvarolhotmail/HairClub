/* CreateDate: 10/15/2013 00:47:39.983 , ModifyDate: 05/19/2014 08:48:36.157 */
GO
CREATE TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week](
	[queue_queue_schedule_by_day_of_week_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_schedule_by_day_of_week_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
 CONSTRAINT [PK_csta_queue_queue_schedule_by_day_of_week] PRIMARY KEY CLUSTERED
(
	[queue_queue_schedule_by_day_of_week_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [csta_queue_queue_schedule_by_day_of_week_i2] ON [dbo].[csta_queue_queue_schedule_by_day_of_week]
(
	[queue_id] ASC,
	[queue_schedule_by_day_of_week_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week] ADD  CONSTRAINT [DF_csta_queue_queue_schedule_by_day_of_week_active]  DEFAULT (N'Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_csta_queue] FOREIGN KEY([queue_id])
REFERENCES [dbo].[csta_queue] ([queue_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_csta_queue]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_csta_queue_schedule_by_day_of_week] FOREIGN KEY([queue_schedule_by_day_of_week_id])
REFERENCES [dbo].[csta_queue_schedule_by_day_of_week] ([queue_schedule_by_day_of_week_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_csta_queue_schedule_by_day_of_week]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_updated_by_user]
GO
