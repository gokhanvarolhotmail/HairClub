/* CreateDate: 10/04/2006 16:26:48.297 , ModifyDate: 05/19/2014 08:48:36.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_queue](
	[queue_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_dialer_queue] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_csta_queue] PRIMARY KEY NONCLUSTERED
(
	[queue_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_queue] ADD  CONSTRAINT [DF__csta_queu__activ__1CDC41A7]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_queue]  WITH CHECK ADD  CONSTRAINT [onca_campaign_csta_queue_001] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[csta_queue] CHECK CONSTRAINT [onca_campaign_csta_queue_001]
GO
ALTER TABLE [dbo].[csta_queue]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_queue_767] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue] CHECK CONSTRAINT [onca_user_csta_queue_767]
GO
ALTER TABLE [dbo].[csta_queue]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_queue_768] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_queue] CHECK CONSTRAINT [onca_user_csta_queue_768]
GO
ALTER TABLE [dbo].[csta_queue]  WITH CHECK ADD  CONSTRAINT [onct_object_csta_queue_766] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[csta_queue] CHECK CONSTRAINT [onct_object_csta_queue_766]
GO
