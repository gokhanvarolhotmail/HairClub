/* CreateDate: 03/01/2006 09:36:47.350 , ModifyDate: 06/21/2012 10:01:00.357 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_download_item](
	[download_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[download_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[download_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [PK__onca_download_it__1A9FBED1] PRIMARY KEY CLUSTERED
(
	[download_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_download_item_i1] ON [dbo].[onca_download_item]
(
	[download_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_download_item_i2] ON [dbo].[onca_download_item]
(
	[download_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_download_item]  WITH CHECK ADD  CONSTRAINT [download_download_ite_422] FOREIGN KEY([download_id])
REFERENCES [dbo].[onca_download] ([download_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_download_item] CHECK CONSTRAINT [download_download_ite_422]
GO
ALTER TABLE [dbo].[onca_download_item]  WITH CHECK ADD  CONSTRAINT [download_gro_download_ite_421] FOREIGN KEY([download_group_id])
REFERENCES [dbo].[onca_download_group] ([download_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_download_item] CHECK CONSTRAINT [download_gro_download_ite_421]
GO
