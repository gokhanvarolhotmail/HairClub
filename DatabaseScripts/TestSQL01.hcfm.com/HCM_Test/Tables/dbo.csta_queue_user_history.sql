/* CreateDate: 10/15/2013 00:24:55.597 , ModifyDate: 05/21/2015 18:32:12.323 */
/* ***HasTriggers*** TriggerCount: 1 */
GO
CREATE TABLE [dbo].[csta_queue_user_history](
	[queue_user_history_id] [uniqueidentifier] NOT NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_csta_queue_user_history] PRIMARY KEY CLUSTERED
(
	[queue_user_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [csta_queue_user_history_i1] ON [dbo].[csta_queue_user_history]
(
	[end_date] ASC,
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_user_history] ADD  CONSTRAINT [DF_csta_queue_user_history_queue_user_history_id]  DEFAULT (newid()) FOR [queue_user_history_id]
GO
CREATE TRIGGER [dbo].[pso_SingleActiveQueueHistory]
   ON  [dbo].[csta_queue_user_history]
   AFTER INSERT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE csta_queue_user_history
	SET end_date = GETDATE()
	FROM csta_queue_user_history
	INNER JOIN inserted ON
		csta_queue_user_history.user_code = inserted.user_code AND
		inserted.queue_user_history_id <> csta_queue_user_history.queue_user_history_id
	WHERE csta_queue_user_history.end_date IS NULL

END
GO
ALTER TABLE [dbo].[csta_queue_user_history] ENABLE TRIGGER [pso_SingleActiveQueueHistory]
GO
