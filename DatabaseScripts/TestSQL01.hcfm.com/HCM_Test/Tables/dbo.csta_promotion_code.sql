/* CreateDate: 10/04/2006 16:26:48.283 , ModifyDate: 10/23/2017 12:35:40.113 */
GO
CREATE TABLE [dbo].[csta_promotion_code](
	[promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_promotion_code] PRIMARY KEY NONCLUSTERED
(
	[promotion_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_promotion_code] ADD  CONSTRAINT [DF__csta_prom__activ__05F8DC4F]  DEFAULT ('Y') FOR [active]
GO
