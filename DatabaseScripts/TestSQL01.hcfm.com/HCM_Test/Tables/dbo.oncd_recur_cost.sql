/* CreateDate: 01/18/2005 09:34:09.890 , ModifyDate: 06/21/2012 10:04:53.497 */
GO
CREATE TABLE [dbo].[oncd_recur_cost](
	[recur_cost_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[recur_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cost_group_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[amount] [decimal](15, 4) NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_recur_cost] PRIMARY KEY CLUSTERED
(
	[recur_cost_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_recur_cost_i2] ON [dbo].[oncd_recur_cost]
(
	[recur_id] ASC,
	[sort_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_recur_cost]  WITH NOCHECK ADD  CONSTRAINT [cost_group_recur_cost_482] FOREIGN KEY([cost_group_code])
REFERENCES [dbo].[onca_cost_group] ([cost_group_code])
GO
ALTER TABLE [dbo].[oncd_recur_cost] CHECK CONSTRAINT [cost_group_recur_cost_482]
GO
ALTER TABLE [dbo].[oncd_recur_cost]  WITH NOCHECK ADD  CONSTRAINT [recur_recur_cost_212] FOREIGN KEY([recur_id])
REFERENCES [dbo].[oncd_recur] ([recur_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_recur_cost] CHECK CONSTRAINT [recur_recur_cost_212]
GO
ALTER TABLE [dbo].[oncd_recur_cost]  WITH NOCHECK ADD  CONSTRAINT [user_recur_cost_483] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_cost] CHECK CONSTRAINT [user_recur_cost_483]
GO
ALTER TABLE [dbo].[oncd_recur_cost]  WITH NOCHECK ADD  CONSTRAINT [user_recur_cost_484] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_recur_cost] CHECK CONSTRAINT [user_recur_cost_484]
GO
