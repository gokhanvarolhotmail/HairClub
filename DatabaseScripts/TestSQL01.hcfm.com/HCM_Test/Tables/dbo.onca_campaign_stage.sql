/* CreateDate: 01/18/2005 09:34:07.060 , ModifyDate: 06/21/2012 10:01:08.720 */
GO
CREATE TABLE [dbo].[onca_campaign_stage](
	[campaign_stage_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[stage_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stage_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_date] [datetime] NULL,
	[due_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_campaign_stage] PRIMARY KEY CLUSTERED
(
	[campaign_stage_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_campaign_stage]  WITH CHECK ADD  CONSTRAINT [campaign_campaign_sta_275] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_campaign_stage] CHECK CONSTRAINT [campaign_campaign_sta_275]
GO
ALTER TABLE [dbo].[onca_campaign_stage]  WITH CHECK ADD  CONSTRAINT [stage_status_campaign_sta_276] FOREIGN KEY([stage_status_code])
REFERENCES [dbo].[onca_stage_status] ([stage_status_code])
GO
ALTER TABLE [dbo].[onca_campaign_stage] CHECK CONSTRAINT [stage_status_campaign_sta_276]
GO
