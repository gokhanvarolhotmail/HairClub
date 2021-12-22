/* CreateDate: 01/18/2005 09:34:10.343 , ModifyDate: 06/21/2012 10:01:00.583 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_group_setting](
	[group_setting_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_setting] PRIMARY KEY CLUSTERED
(
	[group_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_setting]  WITH CHECK ADD  CONSTRAINT [group_group_settin_234] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_setting] CHECK CONSTRAINT [group_group_settin_234]
GO
ALTER TABLE [dbo].[onca_group_setting]  WITH CHECK ADD  CONSTRAINT [setting_grou_group_settin_242] FOREIGN KEY([setting_group_id])
REFERENCES [dbo].[onca_setting_group] ([setting_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_setting] CHECK CONSTRAINT [setting_grou_group_settin_242]
GO
