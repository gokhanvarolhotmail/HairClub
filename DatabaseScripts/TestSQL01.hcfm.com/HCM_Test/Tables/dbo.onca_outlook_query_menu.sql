/* CreateDate: 06/01/2005 17:18:03.607 , ModifyDate: 06/21/2012 10:00:52.213 */
GO
CREATE TABLE [dbo].[onca_outlook_query_menu](
	[outlook_query_menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_outlook_query_menu] PRIMARY KEY CLUSTERED
(
	[outlook_query_menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
