/* CreateDate: 01/18/2005 09:34:14.733 , ModifyDate: 06/21/2012 10:01:08.790 */
GO
CREATE TABLE [dbo].[onca_chain_activity_user](
	[chain_activity_user_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[chain_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[attendance] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_chain_activity_user] PRIMARY KEY CLUSTERED
(
	[chain_activity_user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_chain_activity_user]  WITH NOCHECK ADD  CONSTRAINT [chain_activi_chain_activi_261] FOREIGN KEY([chain_activity_id])
REFERENCES [dbo].[onca_chain_activity] ([chain_activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_chain_activity_user] CHECK CONSTRAINT [chain_activi_chain_activi_261]
GO
ALTER TABLE [dbo].[onca_chain_activity_user]  WITH NOCHECK ADD  CONSTRAINT [user_chain_activi_815] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onca_chain_activity_user] CHECK CONSTRAINT [user_chain_activi_815]
GO
