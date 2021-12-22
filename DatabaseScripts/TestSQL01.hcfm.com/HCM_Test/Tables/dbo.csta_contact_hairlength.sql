/* CreateDate: 10/04/2006 16:26:48.423 , ModifyDate: 10/23/2017 12:35:40.130 */
GO
CREATE TABLE [dbo].[csta_contact_hairlength](
	[hairlength_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[price] [decimal](15, 4) NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_contact_hairlength] PRIMARY KEY NONCLUSTERED
(
	[hairlength_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_contact_hairlength] ADD  CONSTRAINT [DF__csta_cont__activ__247D636F]  DEFAULT ('Y') FOR [active]
GO
