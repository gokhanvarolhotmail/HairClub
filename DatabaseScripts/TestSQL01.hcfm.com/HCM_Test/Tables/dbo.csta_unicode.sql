/* CreateDate: 09/01/2011 09:52:49.973 , ModifyDate: 06/21/2012 10:00:01.813 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_unicode](
	[unicode_code] [int] NOT NULL,
	[ascii_code] [int] NOT NULL,
 CONSTRAINT [PK_csta_unicode] PRIMARY KEY CLUSTERED
(
	[unicode_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
