/* CreateDate: 02/01/2005 14:59:47.513 , ModifyDate: 06/21/2012 10:00:47.313 */
GO
CREATE TABLE [dbo].[onca_select_query](
	[select_query_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_text] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[initial_filter] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[auto_return] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[force_reload] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_select_query] PRIMARY KEY CLUSTERED
(
	[select_query_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_select_query]  WITH NOCHECK ADD  CONSTRAINT [object_select_query_366] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_select_query] CHECK CONSTRAINT [object_select_query_366]
GO
