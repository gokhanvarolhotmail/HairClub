/* CreateDate: 01/17/2006 15:14:25.363 , ModifyDate: 06/21/2012 10:01:08.710 */
GO
CREATE TABLE [dbo].[onca_campaign_cost](
	[campaign_cost_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cost_group_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[amount] [decimal](15, 4) NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_campaign_cost] PRIMARY KEY CLUSTERED
(
	[campaign_cost_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_campaign_cost]  WITH NOCHECK ADD  CONSTRAINT [campaign_campaign_cos_405] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_campaign_cost] CHECK CONSTRAINT [campaign_campaign_cos_405]
GO
ALTER TABLE [dbo].[onca_campaign_cost]  WITH NOCHECK ADD  CONSTRAINT [cost_group_campaign_cos_406] FOREIGN KEY([cost_group_code])
REFERENCES [dbo].[onca_cost_group] ([cost_group_code])
GO
ALTER TABLE [dbo].[onca_campaign_cost] CHECK CONSTRAINT [cost_group_campaign_cos_406]
GO
