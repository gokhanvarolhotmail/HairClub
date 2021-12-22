/* CreateDate: 10/15/2013 00:22:16.317 , ModifyDate: 05/19/2014 08:48:36.150 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_queue_filter](
	[queue_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[expression_prefix] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[relational_operator] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_value] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[expression_suffix] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_operator] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datatype] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_queue_filter] PRIMARY KEY CLUSTERED
(
	[queue_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue_filter]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_filter_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_filter] CHECK CONSTRAINT [FK_csta_queue_filter_created_by_user]
GO
ALTER TABLE [dbo].[csta_queue_filter]  WITH NOCHECK ADD  CONSTRAINT [FK_csta_queue_filter_csta_queue] FOREIGN KEY([queue_id])
REFERENCES [dbo].[csta_queue] ([queue_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_queue_filter] CHECK CONSTRAINT [FK_csta_queue_filter_csta_queue]
GO
ALTER TABLE [dbo].[csta_queue_filter]  WITH CHECK ADD  CONSTRAINT [FK_csta_queue_filter_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue_filter] CHECK CONSTRAINT [FK_csta_queue_filter_updated_by_user]
GO
