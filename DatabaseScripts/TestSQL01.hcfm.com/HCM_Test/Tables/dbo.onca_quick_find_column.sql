/* CreateDate: 02/01/2005 14:59:47.200 , ModifyDate: 06/21/2012 10:00:47.127 */
GO
CREATE TABLE [dbo].[onca_quick_find_column](
	[quick_find_column_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[quick_find_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[column_name] [nchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[prefix] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[suffix] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datatype] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_quick_find_column] PRIMARY KEY CLUSTERED
(
	[quick_find_column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_quick_find_column]  WITH NOCHECK ADD  CONSTRAINT [quick_find_quick_find_c_364] FOREIGN KEY([quick_find_id])
REFERENCES [dbo].[onca_quick_find] ([quick_find_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_quick_find_column] CHECK CONSTRAINT [quick_find_quick_find_c_364]
GO
