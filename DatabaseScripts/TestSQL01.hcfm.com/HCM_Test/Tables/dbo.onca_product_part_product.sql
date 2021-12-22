/* CreateDate: 01/25/2010 10:44:07.840 , ModifyDate: 06/21/2012 10:00:52.247 */
GO
CREATE TABLE [dbo].[onca_product_part_product](
	[product_part_product_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[part_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_product_part_product] PRIMARY KEY CLUSTERED
(
	[product_part_product_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_product_part_product]  WITH CHECK ADD  CONSTRAINT [product_part_product_part_1083] FOREIGN KEY([part_code])
REFERENCES [dbo].[onca_product_part] ([part_code])
GO
ALTER TABLE [dbo].[onca_product_part_product] CHECK CONSTRAINT [product_part_product_part_1083]
GO
ALTER TABLE [dbo].[onca_product_part_product]  WITH CHECK ADD  CONSTRAINT [product_product_part_1084] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[onca_product_part_product] CHECK CONSTRAINT [product_product_part_1084]
GO
