/* CreateDate: 01/18/2005 09:34:09.657 , ModifyDate: 06/21/2012 10:04:23.343 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_class_category_reference](
	[class_category_reference_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[class_category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reference_source] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reference_type_code] [nchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reference_name] [nchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_class_category_reference] PRIMARY KEY CLUSTERED
(
	[class_category_reference_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_category_refere_i02] ON [dbo].[onct_class_category_reference]
(
	[class_category_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_category_refere_i03] ON [dbo].[onct_class_category_reference]
(
	[reference_type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_class_category_reference]  WITH CHECK ADD  CONSTRAINT [class_catego_class_catego_119] FOREIGN KEY([class_category_code])
REFERENCES [dbo].[onct_class_category] ([class_category_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_class_category_reference] CHECK CONSTRAINT [class_catego_class_catego_119]
GO
