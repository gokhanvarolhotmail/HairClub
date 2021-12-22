/* CreateDate: 10/04/2006 16:26:48.547 , ModifyDate: 06/21/2012 10:00:01.800 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_script_type](
	[type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_script_type] PRIMARY KEY NONCLUSTERED
(
	[type_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_script_type] ADD  CONSTRAINT [DF__csta_scri__activ__18178C8A]  DEFAULT ('Y') FOR [active]
GO
