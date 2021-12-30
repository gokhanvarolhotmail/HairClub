/* CreateDate: 05/24/2007 10:53:30.880 , ModifyDate: 06/21/2012 10:00:00.233 */
GO
CREATE TABLE [dbo].[csta_hair_loss_level](
	[hair_loss_level_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK__csta_hair_loss_l__40B12477] PRIMARY KEY CLUSTERED
(
	[hair_loss_level_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_hair_loss_level] ADD  DEFAULT ('Y') FOR [active]
GO
