/* CreateDate: 06/01/2005 13:05:20.387 , ModifyDate: 06/21/2012 10:01:08.713 */
GO
CREATE TABLE [dbo].[onca_campaign_note](
	[campaign_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_campaign_note] PRIMARY KEY CLUSTERED
(
	[campaign_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_campaign_note]  WITH CHECK ADD  CONSTRAINT [campaign_campaign_not_133] FOREIGN KEY([campaign_code])
REFERENCES [dbo].[onca_campaign] ([campaign_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_campaign_note] CHECK CONSTRAINT [campaign_campaign_not_133]
GO
