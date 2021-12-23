/* CreateDate: 01/18/2005 09:34:06.920 , ModifyDate: 09/26/2013 14:54:44.793 */
GO
CREATE TABLE [dbo].[onca_action_cost](
	[action_cost_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cost_group_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[amount] [decimal](15, 4) NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_action_cost] PRIMARY KEY CLUSTERED
(
	[action_cost_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_action_cost]  WITH NOCHECK ADD  CONSTRAINT [action_action_cost_127] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_action_cost] CHECK CONSTRAINT [action_action_cost_127]
GO
ALTER TABLE [dbo].[onca_action_cost]  WITH NOCHECK ADD  CONSTRAINT [cost_group_action_cost_138] FOREIGN KEY([cost_group_code])
REFERENCES [dbo].[onca_cost_group] ([cost_group_code])
GO
ALTER TABLE [dbo].[onca_action_cost] CHECK CONSTRAINT [cost_group_action_cost_138]
GO
