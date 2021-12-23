/* CreateDate: 06/19/2008 10:56:13.090 , ModifyDate: 06/21/2012 10:00:00.810 */
GO
CREATE TABLE [dbo].[csta_query_criteria_detail](
	[query_criteria_detail_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[query_criteria_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[expression_prefix] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[relational_operator] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[filter_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[expression_suffix] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_operator] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_query_criteria_detail] PRIMARY KEY CLUSTERED
(
	[query_criteria_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_query_criteria_detail]  WITH NOCHECK ADD  CONSTRAINT [csta_query_criteria_csta_query_criteria_detail_762] FOREIGN KEY([query_criteria_id])
REFERENCES [dbo].[csta_query_criteria] ([query_criteria_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[csta_query_criteria_detail] CHECK CONSTRAINT [csta_query_criteria_csta_query_criteria_detail_762]
GO
ALTER TABLE [dbo].[csta_query_criteria_detail]  WITH NOCHECK ADD  CONSTRAINT [onca_user_csta_query_criteria_detail_763] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_query_criteria_detail] CHECK CONSTRAINT [onca_user_csta_query_criteria_detail_763]
GO
ALTER TABLE [dbo].[csta_query_criteria_detail]  WITH NOCHECK ADD  CONSTRAINT [onca_user_csta_query_criteria_detail_764] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_query_criteria_detail] CHECK CONSTRAINT [onca_user_csta_query_criteria_detail_764]
GO
