/* CreateDate: 02/27/2006 15:15:42.627 , ModifyDate: 06/21/2012 10:01:04.423 */
GO
CREATE TABLE [dbo].[onca_dashboard_menu](
	[dashboard_menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hierarchy] [int] NULL,
 CONSTRAINT [pk_onca_dashboard_menu] PRIMARY KEY CLUSTERED
(
	[dashboard_menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
