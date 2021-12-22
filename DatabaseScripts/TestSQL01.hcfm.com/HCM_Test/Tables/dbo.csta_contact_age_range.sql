/* CreateDate: 11/15/2006 13:18:00.450 , ModifyDate: 10/23/2017 12:35:40.127 */
GO
CREATE TABLE [dbo].[csta_contact_age_range](
	[age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[minimum_age] [int] NULL,
	[maximum_age] [int] NULL,
 CONSTRAINT [pk_csta_contact_age_range] PRIMARY KEY NONCLUSTERED
(
	[age_range_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_age_range] ADD  CONSTRAINT [DF__csta_cont__activ__004002F9]  DEFAULT ('Y') FOR [active]
GO
