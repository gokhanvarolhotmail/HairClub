/* CreateDate: 01/25/2010 10:44:07.887 , ModifyDate: 06/21/2012 10:00:52.257 */
GO
CREATE TABLE [dbo].[onca_product_version_product](
	[product_version_product_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[version_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_product_version_product] PRIMARY KEY CLUSTERED
(
	[product_version_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_product_version_product]  WITH NOCHECK ADD  CONSTRAINT [product_product_vers_1085] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[onca_product_version_product] CHECK CONSTRAINT [product_product_vers_1085]
GO
ALTER TABLE [dbo].[onca_product_version_product]  WITH NOCHECK ADD  CONSTRAINT [product_vers_product_vers_1086] FOREIGN KEY([version_code])
REFERENCES [dbo].[onca_product_version] ([version_code])
GO
ALTER TABLE [dbo].[onca_product_version_product] CHECK CONSTRAINT [product_vers_product_vers_1086]
GO
