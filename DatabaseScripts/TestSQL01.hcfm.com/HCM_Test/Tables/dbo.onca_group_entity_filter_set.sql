/* CreateDate: 01/25/2010 11:09:09.693 , ModifyDate: 06/21/2012 10:01:00.497 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_group_entity_filter_set](
	[group_entity_filter_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_filter_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_entity_filter_set] PRIMARY KEY CLUSTERED
(
	[group_entity_filter_set_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_entity_filter_set]  WITH CHECK ADD  CONSTRAINT [entity_filte_group_entity_1157] FOREIGN KEY([entity_filter_set_id])
REFERENCES [dbo].[onca_entity_filter_set] ([entity_filter_set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_entity_filter_set] CHECK CONSTRAINT [entity_filte_group_entity_1157]
GO
ALTER TABLE [dbo].[onca_group_entity_filter_set]  WITH CHECK ADD  CONSTRAINT [group_group_entity_1158] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_entity_filter_set] CHECK CONSTRAINT [group_group_entity_1158]
GO
