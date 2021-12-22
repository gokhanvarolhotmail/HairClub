/* CreateDate: 06/01/2005 17:18:03.623 , ModifyDate: 06/21/2012 10:00:52.210 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_outlook_query_item](
	[outlook_query_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[outlook_query_menu_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[outlook_query_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_outlook_query_item] PRIMARY KEY CLUSTERED
(
	[outlook_query_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_outlook_query_item]  WITH CHECK ADD  CONSTRAINT [outlook_quer_outlook_quer_399] FOREIGN KEY([outlook_query_menu_id])
REFERENCES [dbo].[onca_outlook_query_menu] ([outlook_query_menu_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_outlook_query_item] CHECK CONSTRAINT [outlook_quer_outlook_quer_399]
GO
ALTER TABLE [dbo].[onca_outlook_query_item]  WITH CHECK ADD  CONSTRAINT [outlook_quer_outlook_quer_400] FOREIGN KEY([outlook_query_id])
REFERENCES [dbo].[onca_outlook_query] ([outlook_query_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_outlook_query_item] CHECK CONSTRAINT [outlook_quer_outlook_quer_400]
GO
