/* CreateDate: 11/08/2012 11:11:30.847 , ModifyDate: 11/08/2012 11:18:28.830 */
GO
CREATE TABLE [dbo].[csta_contact_occupation](
	[occupation_code] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_contact_occupation] PRIMARY KEY NONCLUSTERED
(
	[occupation_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_occupation] ADD  CONSTRAINT [DF__csta_cont__activ__33BFA6FF]  DEFAULT ('Y') FOR [active]
GO
