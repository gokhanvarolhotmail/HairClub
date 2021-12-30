/* CreateDate: 06/19/2008 10:56:13.717 , ModifyDate: 06/21/2012 10:00:00.857 */
GO
CREATE TABLE [dbo].[csta_query_criteria_result](
	[query_criteria_result_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[query_criteria_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[column_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_query_criteria_result] PRIMARY KEY CLUSTERED
(
	[query_criteria_result_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_query_criteria_result]  WITH CHECK ADD  CONSTRAINT [csta_query_criteria_csta_query_criteria_result_765] FOREIGN KEY([query_criteria_id])
REFERENCES [dbo].[csta_query_criteria] ([query_criteria_id])
GO
ALTER TABLE [dbo].[csta_query_criteria_result] CHECK CONSTRAINT [csta_query_criteria_csta_query_criteria_result_765]
GO
ALTER TABLE [dbo].[csta_query_criteria_result]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_query_criteria_result_766] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_query_criteria_result] CHECK CONSTRAINT [onca_user_csta_query_criteria_result_766]
GO
ALTER TABLE [dbo].[csta_query_criteria_result]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_query_criteria_result_767] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_query_criteria_result] CHECK CONSTRAINT [onca_user_csta_query_criteria_result_767]
GO
