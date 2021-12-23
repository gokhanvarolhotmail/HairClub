/* CreateDate: 01/16/2007 07:00:21.250 , ModifyDate: 05/15/2017 09:13:32.163 */
GO
CREATE TABLE [dbo].[csta_script](
	[script_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[priority] [int] NULL,
	[gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[from_date] [datetime] NOT NULL,
	[to_date] [datetime] NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[default_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[language_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_csta_script] PRIMARY KEY NONCLUSTERED
(
	[script_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script] ADD  CONSTRAINT [DF__csta_scri__activ__08D548FA]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_script] ADD  CONSTRAINT [DF__csta_scri__defau__09C96D33]  DEFAULT (' ') FOR [default_flag]
GO
ALTER TABLE [dbo].[csta_script]  WITH NOCHECK ADD  CONSTRAINT [csta_contact_language_csta_script_817] FOREIGN KEY([language_code])
REFERENCES [dbo].[csta_contact_language] ([language_code])
GO
ALTER TABLE [dbo].[csta_script] CHECK CONSTRAINT [csta_contact_language_csta_script_817]
GO
ALTER TABLE [dbo].[csta_script]  WITH NOCHECK ADD  CONSTRAINT [csta_script_category_csta_script_761] FOREIGN KEY([category_code])
REFERENCES [dbo].[csta_script_category] ([category_code])
GO
ALTER TABLE [dbo].[csta_script] CHECK CONSTRAINT [csta_script_category_csta_script_761]
GO
ALTER TABLE [dbo].[csta_script]  WITH NOCHECK ADD  CONSTRAINT [csta_script_type_csta_script_762] FOREIGN KEY([type_code])
REFERENCES [dbo].[csta_script_type] ([type_code])
GO
ALTER TABLE [dbo].[csta_script] CHECK CONSTRAINT [csta_script_type_csta_script_762]
GO
ALTER TABLE [dbo].[csta_script]  WITH NOCHECK ADD  CONSTRAINT [onca_user_csta_script_771] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_script] CHECK CONSTRAINT [onca_user_csta_script_771]
GO
ALTER TABLE [dbo].[csta_script]  WITH NOCHECK ADD  CONSTRAINT [onca_user_csta_script_772] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_script] CHECK CONSTRAINT [onca_user_csta_script_772]
GO
