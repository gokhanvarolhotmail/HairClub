/* CreateDate: 01/18/2005 09:34:14.953 , ModifyDate: 09/26/2013 14:54:44.847 */
GO
CREATE TABLE [dbo].[onca_milestone_activity](
	[milestone_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[duration] [int] NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[project_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_milestone_activity] PRIMARY KEY CLUSTERED
(
	[milestone_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH NOCHECK ADD  CONSTRAINT [action_milestone_ac_270] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [action_milestone_ac_270]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [address_type_milestone_ac_845] FOREIGN KEY([batch_address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [address_type_milestone_ac_845]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [batch_status_milestone_ac_849] FOREIGN KEY([batch_status_code])
REFERENCES [dbo].[onca_batch_status] ([batch_status_code])
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [batch_status_milestone_ac_849]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [campaign_milestone_ac_850] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [campaign_milestone_ac_850]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [milestone_milestone_ac_272] FOREIGN KEY([milestone_id])
REFERENCES [dbo].[onca_milestone] ([milestone_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [milestone_milestone_ac_272]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [project_milestone_ac_851] FOREIGN KEY([project_code])
REFERENCES [dbo].[onca_project] ([project_code])
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [project_milestone_ac_851]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [result_milestone_ac_848] FOREIGN KEY([batch_result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [result_milestone_ac_848]
GO
ALTER TABLE [dbo].[onca_milestone_activity]  WITH CHECK ADD  CONSTRAINT [source_milestone_ac_852] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[onca_milestone_activity] CHECK CONSTRAINT [source_milestone_ac_852]
GO
