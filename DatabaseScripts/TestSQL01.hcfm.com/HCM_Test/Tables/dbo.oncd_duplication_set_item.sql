/* CreateDate: 01/18/2005 09:34:20.687 , ModifyDate: 06/21/2012 10:05:29.287 */
GO
CREATE TABLE [dbo].[oncd_duplication_set_item](
	[item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_key] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[survivor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[merge_header] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[merge_detail] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_duplication_set_item] PRIMARY KEY CLUSTERED
(
	[item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_duplication_set_item_i2] ON [dbo].[oncd_duplication_set_item]
(
	[set_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_duplication_set_item]  WITH NOCHECK ADD  CONSTRAINT [duplication__duplication__336] FOREIGN KEY([set_id])
REFERENCES [dbo].[oncd_duplication_set] ([set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_duplication_set_item] CHECK CONSTRAINT [duplication__duplication__336]
GO
