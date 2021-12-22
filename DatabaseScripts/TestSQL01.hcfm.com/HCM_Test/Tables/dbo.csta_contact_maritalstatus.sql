/* CreateDate: 10/04/2006 16:26:48.267 , ModifyDate: 10/23/2017 12:35:40.110 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_contact_maritalstatus](
	[maritalstatus_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_contact_maritalstatus] PRIMARY KEY NONCLUSTERED
(
	[maritalstatus_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_maritalstatus] ADD  CONSTRAINT [DF__csta_cont__activ__2E06CDA9]  DEFAULT ('Y') FOR [active]
GO
