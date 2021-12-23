/* CreateDate: 11/08/2012 13:46:06.160 , ModifyDate: 11/08/2012 13:46:26.033 */
GO
CREATE TABLE [dbo].[onca_campaign](
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_status] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[manager_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[target_number] [int] NULL,
	[response_number] [int] NULL,
	[company_type] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[budget_cost] [decimal](15, 4) NULL,
	[actual_cost] [decimal](15, 4) NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_method_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_campaign] PRIMARY KEY CLUSTERED
(
	[campaign_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_campaign]  WITH NOCHECK ADD  CONSTRAINT [campaign_sta_campaign_1139] FOREIGN KEY([campaign_status])
REFERENCES [dbo].[onca_campaign_status] ([campaign_status_code])
GO
ALTER TABLE [dbo].[onca_campaign] CHECK CONSTRAINT [campaign_sta_campaign_1139]
GO
ALTER TABLE [dbo].[onca_campaign]  WITH NOCHECK ADD  CONSTRAINT [method_campaign_1140] FOREIGN KEY([campaign_method_code])
REFERENCES [dbo].[onca_method] ([method_id])
GO
ALTER TABLE [dbo].[onca_campaign] CHECK CONSTRAINT [method_campaign_1140]
GO
ALTER TABLE [dbo].[onca_campaign]  WITH NOCHECK ADD  CONSTRAINT [user_campaign_807] FOREIGN KEY([manager_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onca_campaign] CHECK CONSTRAINT [user_campaign_807]
GO