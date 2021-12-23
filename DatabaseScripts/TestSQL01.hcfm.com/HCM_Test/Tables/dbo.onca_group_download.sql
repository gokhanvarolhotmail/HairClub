/* CreateDate: 03/01/2006 09:36:47.317 , ModifyDate: 06/21/2012 10:01:00.497 */
GO
CREATE TABLE [dbo].[onca_group_download](
	[group_download_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[download_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK__onca_group_downl__15DB09B4] PRIMARY KEY CLUSTERED
(
	[group_download_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_group_download_i1] ON [dbo].[onca_group_download]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onca_group_download_i2] ON [dbo].[onca_group_download]
(
	[download_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_download]  WITH NOCHECK ADD  CONSTRAINT [download_gro_group_downlo_420] FOREIGN KEY([download_group_id])
REFERENCES [dbo].[onca_download_group] ([download_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_download] CHECK CONSTRAINT [download_gro_group_downlo_420]
GO
ALTER TABLE [dbo].[onca_group_download]  WITH NOCHECK ADD  CONSTRAINT [group_group_downlo_416] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_download] CHECK CONSTRAINT [group_group_downlo_416]
GO
