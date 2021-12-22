/* CreateDate: 01/18/2005 09:34:14.297 , ModifyDate: 06/21/2012 10:04:13.593 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_object_group_member](
	[object_group_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_object_group_member] PRIMARY KEY CLUSTERED
(
	[object_group_member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_object_group_member_i2] ON [dbo].[onct_object_group_member]
(
	[object_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_object_group_member_i3] ON [dbo].[onct_object_group_member]
(
	[object_id] ASC,
	[object_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_object_group_member]  WITH CHECK ADD  CONSTRAINT [object_group_object_group_184] FOREIGN KEY([object_group_id])
REFERENCES [dbo].[onct_object_group] ([object_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_object_group_member] CHECK CONSTRAINT [object_group_object_group_184]
GO
ALTER TABLE [dbo].[onct_object_group_member]  WITH CHECK ADD  CONSTRAINT [object_object_group_185] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_object_group_member] CHECK CONSTRAINT [object_object_group_185]
GO
