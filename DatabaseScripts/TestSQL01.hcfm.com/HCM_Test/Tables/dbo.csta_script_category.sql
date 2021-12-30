/* CreateDate: 10/04/2006 16:26:48.517 , ModifyDate: 11/25/2013 09:39:38.057 */
GO
CREATE TABLE [dbo].[csta_script_category](
	[category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[number_of_scripts] [int] NULL,
 CONSTRAINT [pk_csta_script_category] PRIMARY KEY NONCLUSTERED
(
	[category_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script_category] ADD  CONSTRAINT [DF__csta_scri__activ__153B1FDF]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_script_category] ADD  CONSTRAINT [DF__csta_scri__numbe__162F4418]  DEFAULT ((0)) FOR [number_of_scripts]
GO
