/* CreateDate: 01/25/2010 11:09:43.757 , ModifyDate: 06/21/2012 10:03:52.610 */
GO
CREATE TABLE [dbo].[onct_toolbox_group_item](
	[toolbox_group_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[toolbox_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[image_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_text] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_toolbox_group_item] PRIMARY KEY CLUSTERED
(
	[toolbox_group_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_toolbox_group_item_i2] ON [dbo].[onct_toolbox_group_item]
(
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [onct_toolbox_group_item_i3] ON [dbo].[onct_toolbox_group_item]
(
	[toolbox_group_id] ASC,
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_toolbox_group_item]  WITH NOCHECK ADD  CONSTRAINT [class_toolbox_grou_116] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
GO
ALTER TABLE [dbo].[onct_toolbox_group_item] CHECK CONSTRAINT [class_toolbox_grou_116]
GO
ALTER TABLE [dbo].[onct_toolbox_group_item]  WITH NOCHECK ADD  CONSTRAINT [toolbox_grou_toolbox_grou_57] FOREIGN KEY([toolbox_group_id])
REFERENCES [dbo].[onct_toolbox_group] ([toolbox_group_id])
GO
ALTER TABLE [dbo].[onct_toolbox_group_item] CHECK CONSTRAINT [toolbox_grou_toolbox_grou_57]
GO
