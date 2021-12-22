/* CreateDate: 01/18/2005 09:34:07.750 , ModifyDate: 06/21/2012 10:00:52.233 */
GO
CREATE TABLE [dbo].[onca_product](
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[manufacturer_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[unit_price] [decimal](15, 4) NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_product] PRIMARY KEY CLUSTERED
(
	[product_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_product]  WITH CHECK ADD  CONSTRAINT [manufacturer_product_856] FOREIGN KEY([manufacturer_code])
REFERENCES [dbo].[onca_manufacturer] ([manufacturer_code])
GO
ALTER TABLE [dbo].[onca_product] CHECK CONSTRAINT [manufacturer_product_856]
GO
