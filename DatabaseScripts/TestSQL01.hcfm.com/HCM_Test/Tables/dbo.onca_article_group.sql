/* CreateDate: 03/01/2006 09:36:47.350 , ModifyDate: 06/21/2012 10:01:08.683 */
GO
CREATE TABLE [dbo].[onca_article_group](
	[article_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__onca_article_gro__03BC5979] PRIMARY KEY CLUSTERED
(
	[article_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
