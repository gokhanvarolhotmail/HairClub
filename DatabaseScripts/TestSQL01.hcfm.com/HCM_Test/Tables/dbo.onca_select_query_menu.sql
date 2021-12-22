/* CreateDate: 02/01/2005 14:59:47.730 , ModifyDate: 06/21/2012 10:00:47.333 */
GO
CREATE TABLE [dbo].[onca_select_query_menu](
	[select_query_menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_select_query_menu] PRIMARY KEY CLUSTERED
(
	[select_query_menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
