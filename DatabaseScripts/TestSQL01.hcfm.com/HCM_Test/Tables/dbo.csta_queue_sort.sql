/* CreateDate: 10/15/2013 00:30:29.210 , ModifyDate: 05/19/2014 08:48:36.160 */
GO
CREATE TABLE [dbo].[csta_queue_sort](
	[queue_sort_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_direction] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
 CONSTRAINT [PK_csta_queue_sort] PRIMARY KEY CLUSTERED
(
	[queue_sort_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_sort]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_sort_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_sort] CHECK CONSTRAINT [FK_csta_queue_sort_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_sort]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_sort_csta_queue] FOREIGN KEY([queue_id])
REFERENCES [dbo].[csta_queue] ([queue_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_sort] CHECK CONSTRAINT [FK_csta_queue_sort_csta_queue]
GO
ALTER TABLE [dbo].[csta_queue_sort]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_sort_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_sort] CHECK CONSTRAINT [FK_csta_queue_sort_updated_by_user]
GO
