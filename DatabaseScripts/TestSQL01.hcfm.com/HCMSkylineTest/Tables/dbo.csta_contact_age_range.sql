/* CreateDate: 11/08/2012 11:24:25.537 , ModifyDate: 11/08/2012 13:46:26.063 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
