/* CreateDate: 10/04/2006 16:26:48.440 , ModifyDate: 10/23/2017 12:35:40.133 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
