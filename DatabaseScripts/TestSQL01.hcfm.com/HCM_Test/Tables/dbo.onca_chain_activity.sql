/* CreateDate: 01/18/2005 09:34:14.687 , ModifyDate: 09/26/2013 14:54:44.807 */
GO
CREATE TABLE [dbo].[onca_chain_activity](
	[chain_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[chain_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[day_offset] [int] NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batch_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_weekend_days] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_time] [datetime] NULL,
	[duration] [int] NULL,
	[notify_when_completed] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[include_initial] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_chain_activity] PRIMARY KEY CLUSTERED
(
	[chain_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_chain_activity]  WITH NOCHECK ADD  CONSTRAINT [action_chain_activi_263] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_chain_activity] CHECK CONSTRAINT [action_chain_activi_263]
GO
ALTER TABLE [dbo].[onca_chain_activity]  WITH CHECK ADD  CONSTRAINT [address_type_chain_activi_811] FOREIGN KEY([batch_address_type_code])
REFERENCES [dbo].[onca_address_type] ([address_type_code])
GO
ALTER TABLE [dbo].[onca_chain_activity] CHECK CONSTRAINT [address_type_chain_activi_811]
GO
ALTER TABLE [dbo].[onca_chain_activity]  WITH CHECK ADD  CONSTRAINT [batch_status_chain_activi_813] FOREIGN KEY([batch_status_code])
REFERENCES [dbo].[onca_batch_status] ([batch_status_code])
GO
ALTER TABLE [dbo].[onca_chain_activity] CHECK CONSTRAINT [batch_status_chain_activi_813]
GO
ALTER TABLE [dbo].[onca_chain_activity]  WITH CHECK ADD  CONSTRAINT [chain_chain_activi_260] FOREIGN KEY([chain_id])
REFERENCES [dbo].[onca_chain] ([chain_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_chain_activity] CHECK CONSTRAINT [chain_chain_activi_260]
GO
ALTER TABLE [dbo].[onca_chain_activity]  WITH CHECK ADD  CONSTRAINT [result_chain_activi_812] FOREIGN KEY([batch_result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[onca_chain_activity] CHECK CONSTRAINT [result_chain_activi_812]
GO
ALTER TABLE [dbo].[onca_chain_activity]  WITH CHECK ADD  CONSTRAINT [result_chain_activi_814] FOREIGN KEY([result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[onca_chain_activity] CHECK CONSTRAINT [result_chain_activi_814]
GO
