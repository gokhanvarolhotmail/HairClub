/* CreateDate: 01/18/2005 09:34:14.187 , ModifyDate: 06/21/2012 10:04:17.277 */
GO
CREATE TABLE [dbo].[onct_entity_process](
	[process_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_entity_process] PRIMARY KEY CLUSTERED
(
	[process_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_process_i2] ON [dbo].[onct_entity_process]
(
	[entity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_process_i3] ON [dbo].[onct_entity_process]
(
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_entity_process_i4] ON [dbo].[onct_entity_process]
(
	[object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_entity_process]  WITH NOCHECK ADD  CONSTRAINT [class_entity_proce_193] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
GO
ALTER TABLE [dbo].[onct_entity_process] CHECK CONSTRAINT [class_entity_proce_193]
GO
ALTER TABLE [dbo].[onct_entity_process]  WITH NOCHECK ADD  CONSTRAINT [entity_entity_proce_191] FOREIGN KEY([entity_id])
REFERENCES [dbo].[onct_entity] ([entity_id])
GO
ALTER TABLE [dbo].[onct_entity_process] CHECK CONSTRAINT [entity_entity_proce_191]
GO
ALTER TABLE [dbo].[onct_entity_process]  WITH NOCHECK ADD  CONSTRAINT [object_entity_proce_192] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onct_entity_process] CHECK CONSTRAINT [object_entity_proce_192]
GO
