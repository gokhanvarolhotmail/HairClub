/* CreateDate: 11/08/2012 13:46:26.017 , ModifyDate: 11/08/2012 13:46:48.020 */
GO
CREATE TABLE [dbo].[onca_source](
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dnis_number] [int] NULL,
	[cst_promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_hair_loss_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_language_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_created_date] [datetime] NULL,
	[cst_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_updated_date] [datetime] NULL,
	[publish] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_source] PRIMARY KEY CLUSTERED
(
	[source_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_source]  WITH CHECK ADD  CONSTRAINT [campaign_source_277] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
GO
ALTER TABLE [dbo].[onca_source] CHECK CONSTRAINT [campaign_source_277]
GO
ALTER TABLE [dbo].[onca_source]  WITH CHECK ADD  CONSTRAINT [csta_contact_age_range_onca_source_774] FOREIGN KEY([cst_age_range_code])
REFERENCES [dbo].[csta_contact_age_range] ([age_range_code])
GO
ALTER TABLE [dbo].[onca_source] CHECK CONSTRAINT [csta_contact_age_range_onca_source_774]
GO
ALTER TABLE [dbo].[onca_source]  WITH CHECK ADD  CONSTRAINT [csta_contact_hair_loss_onca_source_775] FOREIGN KEY([cst_hair_loss_code])
REFERENCES [dbo].[csta_contact_hair_loss] ([hair_loss_code])
GO
ALTER TABLE [dbo].[onca_source] CHECK CONSTRAINT [csta_contact_hair_loss_onca_source_775]
GO
ALTER TABLE [dbo].[onca_source]  WITH CHECK ADD  CONSTRAINT [csta_contact_language_onca_source_776] FOREIGN KEY([cst_language_code])
REFERENCES [dbo].[csta_contact_language] ([language_code])
GO
ALTER TABLE [dbo].[onca_source] CHECK CONSTRAINT [csta_contact_language_onca_source_776]
GO
ALTER TABLE [dbo].[onca_source]  WITH CHECK ADD  CONSTRAINT [csta_promotion_code_onca_source_773] FOREIGN KEY([cst_promotion_code])
REFERENCES [dbo].[csta_promotion_code] ([promotion_code])
GO
ALTER TABLE [dbo].[onca_source] CHECK CONSTRAINT [csta_promotion_code_onca_source_773]
GO
