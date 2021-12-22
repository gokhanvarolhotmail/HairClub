/* CreateDate: 10/04/2006 16:26:48.533 , ModifyDate: 06/21/2012 10:00:01.803 */
GO
CREATE TABLE [dbo].[csta_sub_source](
	[sub_source_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_sub_source] PRIMARY KEY NONCLUSTERED
(
	[sub_source_code] ASC,
	[source_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_sub_source] ADD  CONSTRAINT [DF__csta_sub___activ__031C6FA4]  DEFAULT ('Y') FOR [active]
GO
