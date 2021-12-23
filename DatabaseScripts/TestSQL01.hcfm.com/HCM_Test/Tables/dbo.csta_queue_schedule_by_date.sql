/* CreateDate: 10/15/2013 00:21:22.997 , ModifyDate: 10/15/2013 00:54:14.550 */
GO
CREATE TABLE [dbo].[csta_queue_schedule_by_date](
	[queue_schedule_by_date_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_date] [datetime] NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_queue_schedule_by_date] PRIMARY KEY CLUSTERED
(
	[queue_schedule_by_date_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [csta_queue_schedule_by_date_i2] ON [dbo].[csta_queue_schedule_by_date]
(
	[queue_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_date] ADD  CONSTRAINT [DF_csta_queue_schedule_by_date_active]  DEFAULT (N'Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_schedule_by_date_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_date] CHECK CONSTRAINT [FK_csta_queue_schedule_by_date_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_date]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_schedule_by_date_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_schedule_by_date] CHECK CONSTRAINT [FK_csta_queue_schedule_by_date_updated_by_user]
GO
