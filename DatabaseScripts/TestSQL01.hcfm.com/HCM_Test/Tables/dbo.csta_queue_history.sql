/* CreateDate: 10/15/2013 00:27:22.427 , ModifyDate: 05/21/2015 18:32:21.907 */
GO
CREATE TABLE [dbo].[csta_queue_history](
	[queue_history_id] [uniqueidentifier] NOT NULL,
	[queue_date] [datetime] NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_csta_queue_history] PRIMARY KEY CLUSTERED
(
	[queue_history_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [csta_queue_history_i1] ON [dbo].[csta_queue_history]
(
	[queue_id] ASC,
	[queue_date] ASC,
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [csta_queue_history_i2] ON [dbo].[csta_queue_history]
(
	[queue_date] ASC,
	[activity_id] ASC
)
INCLUDE([queue_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [csta_queue_history_i3] ON [dbo].[csta_queue_history]
(
	[activity_id] ASC,
	[queue_date] ASC
)
INCLUDE([queue_history_id],[queue_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_history] ADD  CONSTRAINT [DF_csta_queue_history_queue_history_id]  DEFAULT (newid()) FOR [queue_history_id]
GO
