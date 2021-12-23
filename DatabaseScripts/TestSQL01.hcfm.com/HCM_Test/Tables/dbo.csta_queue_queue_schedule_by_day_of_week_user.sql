/* CreateDate: 10/15/2013 00:25:58.313 , ModifyDate: 07/21/2014 01:13:36.520 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user](
	[queue_queue_schedule_by_day_of_week_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_queue_schedule_by_day_of_week_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_queue_queue_schedule_by_day_of_week_user] PRIMARY KEY CLUSTERED
(
	[queue_queue_schedule_by_day_of_week_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [csta_queue_queue_schedule_by_day_of_week_user_i2] ON [dbo].[csta_queue_queue_schedule_by_day_of_week_user]
(
	[queue_queue_schedule_by_day_of_week_id] ASC,
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_csta_queue_queue_schedule_by_day_of_week] FOREIGN KEY([queue_queue_schedule_by_day_of_week_id])
REFERENCES [dbo].[csta_queue_queue_schedule_by_day_of_week] ([queue_queue_schedule_by_day_of_week_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_csta_queue_queue_schedule_by_day_of_week]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_onca_user] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_onca_user]
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user] CHECK CONSTRAINT [FK_csta_queue_queue_schedule_by_day_of_week_user_updated_by_user]
GO
CREATE TRIGGER [dbo].[QueueUpdateByDayOfWeek]
   ON  [dbo].[csta_queue_queue_schedule_by_day_of_week_user]
   AFTER INSERT, DELETE
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE csta_queue_user_history
	SET end_date = GETDATE()
	FROM csta_queue_user_history
	INNER JOIN deleted ON
		deleted.user_code = csta_queue_user_history.user_code
	INNER JOIN csta_queue_queue_schedule_by_day_of_week sbdow ON
		deleted.queue_queue_schedule_by_day_of_week_id = sbdow.queue_queue_schedule_by_day_of_week_id AND
		sbdow.queue_id =csta_queue_user_history.queue_id
	INNER JOIN onca_user_log ON csta_queue_user_history.user_code = onca_user_log.user_code
	WHERE
	end_date IS NULL

	INSERT INTO csta_queue_user_history (start_date, queue_id, user_code)
	SELECT GETDATE(), queue_id, inserted.user_code
	FROM inserted
	INNER JOIN onca_user_log ON inserted.user_code = onca_user_log.user_code
	INNER JOIN csta_queue_queue_schedule_by_day_of_week sbdow ON
		inserted.queue_queue_schedule_by_day_of_week_id = sbdow.queue_queue_schedule_by_day_of_week_id

END
GO
ALTER TABLE [dbo].[csta_queue_queue_schedule_by_day_of_week_user] ENABLE TRIGGER [QueueUpdateByDayOfWeek]
GO
