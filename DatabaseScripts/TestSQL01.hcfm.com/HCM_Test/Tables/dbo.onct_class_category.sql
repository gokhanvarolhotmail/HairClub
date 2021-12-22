/* CreateDate: 01/18/2005 09:34:09.610 , ModifyDate: 06/21/2012 10:04:23.290 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_class_category](
	[class_category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parent_class_category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_text] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_system_category] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_base_category] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[required_design_mode] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_class_category] PRIMARY KEY CLUSTERED
(
	[class_category_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_category_i2] ON [dbo].[onct_class_category]
(
	[parent_class_category_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_class_category]  WITH CHECK ADD  CONSTRAINT [class_catego_class_catego_300] FOREIGN KEY([parent_class_category_code])
REFERENCES [dbo].[onct_class_category] ([class_category_code])
GO
ALTER TABLE [dbo].[onct_class_category] CHECK CONSTRAINT [class_catego_class_catego_300]
GO
