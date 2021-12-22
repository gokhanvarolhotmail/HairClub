/* CreateDate: 02/04/2005 13:09:23.920 , ModifyDate: 06/21/2012 10:04:45.527 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_publication_node_filter](
	[publication_node_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[publication_node_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[relational_operator] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_operator] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_suffix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncs_publication_node_filter] PRIMARY KEY CLUSTERED
(
	[publication_node_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_publication_node_filter]  WITH CHECK ADD  CONSTRAINT [publication__publication__312] FOREIGN KEY([publication_node_id])
REFERENCES [dbo].[oncs_publication_node] ([publication_node_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_node_filter] CHECK CONSTRAINT [publication__publication__312]
GO
ALTER TABLE [dbo].[oncs_publication_node_filter]  WITH CHECK ADD  CONSTRAINT [table_column_publication__350] FOREIGN KEY([table_name], [column_name])
REFERENCES [dbo].[onct_table_column] ([table_name], [column_name])
GO
ALTER TABLE [dbo].[oncs_publication_node_filter] CHECK CONSTRAINT [table_column_publication__350]
GO
