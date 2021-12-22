/* CreateDate: 01/18/2005 09:34:06.953 , ModifyDate: 09/26/2013 14:54:44.803 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_action_result](
	[action_result_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[chain_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[prompt_for_next] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[opportunity_percent] [int] NULL,
	[opportunity_mode] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[default_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_follow_up_time] [int] NULL,
	[cst_create_activity_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_followup_action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_followup_time_type] [nchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_activity_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_action_result] PRIMARY KEY CLUSTERED
(
	[action_result_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_action_result] ADD  CONSTRAINT [DF__onca_acti__cst_c__7D78A4E7]  DEFAULT ('N') FOR [cst_create_activity_flag]
GO
ALTER TABLE [dbo].[onca_action_result]  WITH NOCHECK ADD  CONSTRAINT [action_action_resul_125] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_action_result] CHECK CONSTRAINT [action_action_resul_125]
GO
ALTER TABLE [dbo].[onca_action_result]  WITH CHECK ADD  CONSTRAINT [chain_action_resul_802] FOREIGN KEY([chain_id])
REFERENCES [dbo].[onca_chain] ([chain_id])
GO
ALTER TABLE [dbo].[onca_action_result] CHECK CONSTRAINT [chain_action_resul_802]
GO
ALTER TABLE [dbo].[onca_action_result]  WITH NOCHECK ADD  CONSTRAINT [onca_action_onca_action_result_822] FOREIGN KEY([cst_followup_action_code])
REFERENCES [dbo].[onca_action] ([action_code])
GO
ALTER TABLE [dbo].[onca_action_result] CHECK CONSTRAINT [onca_action_onca_action_result_822]
GO
ALTER TABLE [dbo].[onca_action_result]  WITH CHECK ADD  CONSTRAINT [result_action_resul_126] FOREIGN KEY([result_code])
REFERENCES [dbo].[onca_result] ([result_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_action_result] CHECK CONSTRAINT [result_action_resul_126]
GO
