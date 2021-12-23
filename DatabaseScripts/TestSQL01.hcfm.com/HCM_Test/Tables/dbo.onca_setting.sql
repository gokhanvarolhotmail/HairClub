/* CreateDate: 01/18/2005 09:34:12.327 , ModifyDate: 06/21/2012 10:00:47.350 */
GO
CREATE TABLE [dbo].[onca_setting](
	[setting_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[setting_value] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_setting] PRIMARY KEY CLUSTERED
(
	[setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_setting]  WITH CHECK ADD  CONSTRAINT [setting_grou_setting_243] FOREIGN KEY([setting_group_id])
REFERENCES [dbo].[onca_setting_group] ([setting_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_setting] CHECK CONSTRAINT [setting_grou_setting_243]
GO
