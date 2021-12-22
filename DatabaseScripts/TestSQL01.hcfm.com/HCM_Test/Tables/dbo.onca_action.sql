/* CreateDate: 01/18/2005 09:34:06.907 , ModifyDate: 10/23/2017 12:35:40.273 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_action](
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[action_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chain_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[schedule_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[prompt_for_schedule] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[available_to_outlook] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[available_to_mobile] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[prompt_for_next] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[cst_noble_exclusion] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_noble_addition] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_is_outbound_call] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_action] PRIMARY KEY CLUSTERED
(
	[action_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_action] ADD  CONSTRAINT [DF_onca_action_cst_noble_exclusion]  DEFAULT ('N') FOR [cst_noble_exclusion]
GO
ALTER TABLE [dbo].[onca_action] ADD  CONSTRAINT [DF_onca_action_cst_noble_addition]  DEFAULT ('N') FOR [cst_noble_addition]
GO
ALTER TABLE [dbo].[onca_action] ADD  CONSTRAINT [DF_onca_action_cst_is_outbound_call]  DEFAULT ('N') FOR [cst_is_outbound_call]
GO
ALTER TABLE [dbo].[onca_action]  WITH CHECK ADD  CONSTRAINT [action_type_action_266] FOREIGN KEY([action_type_code])
REFERENCES [dbo].[onca_action_type] ([action_type_code])
GO
ALTER TABLE [dbo].[onca_action] CHECK CONSTRAINT [action_type_action_266]
GO
ALTER TABLE [dbo].[onca_action]  WITH CHECK ADD  CONSTRAINT [campaign_action_799] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[onca_action] CHECK CONSTRAINT [campaign_action_799]
GO
ALTER TABLE [dbo].[onca_action]  WITH CHECK ADD  CONSTRAINT [chain_action_800] FOREIGN KEY([chain_id])
REFERENCES [dbo].[onca_chain] ([chain_id])
GO
ALTER TABLE [dbo].[onca_action] CHECK CONSTRAINT [chain_action_800]
GO
ALTER TABLE [dbo].[onca_action]  WITH CHECK ADD  CONSTRAINT [FK_onca_action_csta_script_category] FOREIGN KEY([cst_category_code])
REFERENCES [dbo].[csta_script_category] ([category_code])
GO
ALTER TABLE [dbo].[onca_action] CHECK CONSTRAINT [FK_onca_action_csta_script_category]
GO
ALTER TABLE [dbo].[onca_action]  WITH CHECK ADD  CONSTRAINT [source_action_801] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[onca_action] CHECK CONSTRAINT [source_action_801]
GO
