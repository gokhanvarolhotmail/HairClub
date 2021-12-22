/* CreateDate: 11/08/2012 11:11:12.203 , ModifyDate: 11/08/2012 11:18:28.800 */
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
