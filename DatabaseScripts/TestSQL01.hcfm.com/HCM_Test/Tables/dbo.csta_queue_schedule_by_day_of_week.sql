/* CreateDate: 10/15/2013 00:21:03.393 , ModifyDate: 10/15/2013 00:54:14.527 */
GO
CREATE TABLE [dbo].[csta_queue_schedule_by_day_of_week](
	[queue_schedule_by_day_of_week_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[day_of_week] [int] NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_queue_schedule_by_day_of_week] PRIMARY KEY CLUSTERED
(
	[queue_schedule_by_day_of_week_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_day_of_week] ADD  CONSTRAINT [DF_csta_queue_schedule_by_day_of_week_active]  DEFAULT (N'Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_day_of_week]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_schedule_by_day_of_week_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_day_of_week] CHECK CONSTRAINT [FK_csta_queue_schedule_by_day_of_week_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_day_of_week]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_schedule_by_day_of_week_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_day_of_week] CHECK CONSTRAINT [FK_csta_queue_schedule_by_day_of_week_updated_by_user]
GO
