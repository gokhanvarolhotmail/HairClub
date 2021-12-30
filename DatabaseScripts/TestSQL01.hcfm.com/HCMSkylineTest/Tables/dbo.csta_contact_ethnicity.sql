/* CreateDate: 11/08/2012 11:10:54.390 , ModifyDate: 11/08/2012 11:18:28.770 */
GO
CREATE TABLE [dbo].[csta_contact_ethnicity](
	[ethnicity_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_contact_ethnicity] PRIMARY KEY NONCLUSTERED
(
	[ethnicity_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_ethnicity] ADD  CONSTRAINT [DF__csta_cont__activ__21A0F6C4]  DEFAULT ('Y') FOR [active]
GO
