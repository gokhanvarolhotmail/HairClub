/* CreateDate: 02/04/2005 13:09:23.983 , ModifyDate: 06/21/2012 10:04:45.550 */
GO
CREATE TABLE [dbo].[oncs_publication_table_filter](
	[publication_table_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[publication_table_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[relational_operator] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_operator] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_suffix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncs_publication_table_filter] PRIMARY KEY CLUSTERED
(
	[publication_table_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_publication_table_filter]  WITH CHECK ADD  CONSTRAINT [publication__publication__359] FOREIGN KEY([publication_table_id])
REFERENCES [dbo].[oncs_publication_table] ([publication_table_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_publication_table_filter] CHECK CONSTRAINT [publication__publication__359]
GO
