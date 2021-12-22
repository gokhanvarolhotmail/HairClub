/* CreateDate: 10/04/2006 16:26:48.500 , ModifyDate: 10/23/2017 12:35:40.140 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_contact_investment](
	[investment_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[price] [decimal](15, 4) NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[extreme_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_contact_investment] PRIMARY KEY NONCLUSTERED
(
	[investment_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_investment] ADD  CONSTRAINT [DF__csta_cont__activ__2A363CC5]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_contact_investment] ADD  CONSTRAINT [DF__csta_cont__extre__2B2A60FE]  DEFAULT (' ') FOR [extreme_flag]
GO
