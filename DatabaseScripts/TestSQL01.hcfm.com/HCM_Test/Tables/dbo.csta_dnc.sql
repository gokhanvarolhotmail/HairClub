/* CreateDate: 09/30/2013 10:49:54.833 , ModifyDate: 09/30/2013 10:51:29.437 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_dnc](
	[dnc_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[is_wireless] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_csta_dnc] PRIMARY KEY CLUSTERED
(
	[dnc_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_dnc] ADD  CONSTRAINT [DF_csta_dnc_active]  DEFAULT (N'Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_dnc] ADD  CONSTRAINT [DF_csta_dnc_is_wireless]  DEFAULT (N'N') FOR [is_wireless]
GO
